package br.com.clearsale.liveness.flutter.cs_liveness_flutter

import androidx.annotation.NonNull

import android.app.Activity
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.graphics.Color;

import com.clear.studio.csliveness.view.CSLivenessActivity
import com.clear.studio.csliveness.core.CSLiveness
import com.clear.studio.csliveness.core.CSLivenessResult
import com.clear.studio.csliveness.core.CSLivenessConfig
import com.clear.studio.csliveness.core.CSLivenessConfigColors

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

import kotlinx.serialization.*
import kotlinx.serialization.json.*

class CsLivenessFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    private lateinit var channel : MethodChannel
    private var REQUEST_CODE: Int = 200
    var act: Activity? = null
    private var pendingResult: Result? = null

    companion object{
        const val successState: String = "Real"
        const val livenessRecognition: String = "livenessRecognition"
        const val clientId: String = "clientId"
        const val clientSecret: String = "clientSecret"
        const val identifierId: String = "identifierId"
        const val cpf: String = "cpf"
        const val config: String = "config"

        const val cSLivenessError: String = "CSLivenss ERROR"
        const val error: String = "error"
        const val errorMessage: String = "USER CANCEL"
        const val channelId: String = "cs_liveness_flutter"
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, channelId)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        try{
            if (call.method == livenessRecognition){
                val clientID : String? = call.argument(clientId)
                val clientSecret : String? = call.argument(clientSecret)
                val identifierId : String? = call.argument(identifierId)
                val cpf : String? = call.argument(cpf)
                val config : String? = call.argument(config)
                
                pendingResult = result
                livenessRecognition(clientID!!, clientSecret!!, identifierId, cpf, config, result)
            }
            else {
                result.notImplemented()
            }
        } catch(e: Exception){
            Log.i(cSLivenessError, e.message, e)
            e.printStackTrace()
            Handler(Looper.getMainLooper()).post(result::notImplemented)
            result.error(cSLivenessError, error, errorMessage)
        }
    }

    fun livenessRecognition(@NonNull clientID: String, @NonNull clientSecret: String, identifierId: String?, cpf: String?, config: String?, @NonNull result: Result)
    {
        var configuration: Config? = null
        config?.let{
            configuration = Json.decodeFromString<Config?>(it)
        }
        var csColors: CSLivenessConfigColors = CSLivenessConfigColors()
        configuration?.colors?.apply{
            csColors = CSLivenessConfigColors(
                primaryColor = if(primary == null) null else Color.parseColor(primary),
                secondaryColor = if(secondary == null) null else Color.parseColor(secondary),
                titleColor = if(title == null) null else Color.parseColor(title),
                paragraphColor = if(paragraph == null) null else Color.parseColor(paragraph)
                )
        }
        val csConfig: CSLivenessConfig = CSLivenessConfig(configuration?.vocalGuidance?:false, csColors)
 
        var mCSLiveness : CSLiveness = CSLiveness(clientID, clientSecret, identifierId, cpf, csConfig)
        var mIntent : Intent = Intent(act, CSLivenessActivity::class.java)
        mIntent.putExtra("Hybrid","Flutter")
        mIntent.putExtra("PARAMETER_NAME", mCSLiveness)
        act?.startActivityForResult(mIntent, REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean  {
         try{
            if (requestCode == REQUEST_CODE){
                if (resultCode == Activity.RESULT_OK && data != null) {
                    var mCSLivenessResult: CSLivenessResult = data.getSerializableExtra("PARAMETER_NAME") as CSLivenessResult
                    if (mCSLivenessResult.getResponseMessage() == successState){
                        pendingResult?.success("{\"real\": \"${mCSLivenessResult.getResponseMessage()}\",\"sessionId\": \"${mCSLivenessResult.getSessionId()}\",\"image\": \"${mCSLivenessResult.getImage()}\"}")
                    }
                    else{
                        Log.i(cSLivenessError, mCSLivenessResult.getResponseMessage())
                        pendingResult?.error(cSLivenessError, error, mCSLivenessResult.getResponseMessage())
                    }
                } else {
                    pendingResult?.error(cSLivenessError, error, errorMessage)
                }
            }
        } catch (e: Exception){
            pendingResult?.error(cSLivenessError, error, errorMessage)
        }
        return true
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        act = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        act = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        act = null
    }
}
