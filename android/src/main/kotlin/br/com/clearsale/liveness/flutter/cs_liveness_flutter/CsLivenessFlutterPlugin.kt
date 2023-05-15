package br.com.clearsale.liveness.flutter.cs_liveness_flutter

import androidx.annotation.NonNull

import android.app.Activity
import android.content.Intent
import android.os.Handler
import android.os.Looper
import android.util.Log

import com.clear.studio.csliveness.view.CSLivenessActivity
import com.clear.studio.csliveness.core.CSLiveness
import com.clear.studio.csliveness.core.CSLivenessResult

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar


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
        const val vocalGuidance: String = "vocalGuidance"
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
                val vocalGuidance : Boolean? = call.argument(vocalGuidance)
                pendingResult = result
                livenessRecognition(clientID!!, clientSecret!!, vocalGuidance!!, result)
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

    fun livenessRecognition(@NonNull clientID: String, @NonNull clientSecret: String, @NonNull vocalGuidance: Boolean ,@NonNull result: Result){
        var mCSLiveness : CSLiveness = CSLiveness(clientID, clientSecret, vocalGuidance)
        var mIntent : Intent = Intent(act, CSLivenessActivity::class.java)
        mIntent.putExtra("Hybrid","Flutter")
        mIntent.putExtra(CSLiveness.PARAMETER_NAME, mCSLiveness)
        act?.startActivityForResult(mIntent, REQUEST_CODE)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean  {
        try{
            if (requestCode == REQUEST_CODE){
                if (resultCode == Activity.RESULT_OK && data != null) {
                    var mCSLivenessResult: CSLivenessResult = data.getSerializableExtra(CSLiveness.PARAMETER_NAME) as CSLivenessResult
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
