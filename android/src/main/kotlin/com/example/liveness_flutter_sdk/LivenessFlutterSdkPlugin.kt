package com.example.liveness_flutter_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.util.Log
import com.clear.studio.csliveness.core.CSLiveness
import com.clear.studio.csliveness.core.CSLivenessConfig
import com.clear.studio.csliveness.core.CSLivenessConfigColors
import com.clear.studio.csliveness.core.CSLivenessResult
import com.clear.studio.csliveness.view.CSLivenessActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry


/** LivenessFlutterSdkPlugin */
class LivenessFlutterSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var context: Context? = null

    private val requestCode: Int = 40
    private val parameterName: String = "PARAMETER_NAME"
    private var logTag = "[CSLiveness]"

    private var flutterResult: Result? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "liveness_flutter_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "openCSLiveness") {
            openCSLiveness(call, result)
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun resetResult() {
        flutterResult = null
    }

    private fun openCSLiveness(call: MethodCall, result: Result) {
        if (flutterResult !== null) {
            // Means that we are already running and somehow the button got triggered again.
            // In this case just return.

            return
        }

        try {
            flutterResult = result

            val clientId = call.argument<String>("clientId")
            val clientSecretId = call.argument<String>("clientSecretId")
            val identifierId = call.argument<String>("identifierId")
            val cpf = call.argument<String>("cpf")
            val accessToken = call.argument<String>("accessToken")
            val transactionId = call.argument<String>("transactionId")
            val vocalGuidance = call.argument<Boolean>("vocalGuidance")
            val primaryColor = call.argument<String>("primaryColor")
            val secondaryColor = call.argument<String>("secondaryColor")
            val titleColor = call.argument<String>("titleColor")
            val paragraphColor = call.argument<String>("paragraphColor")

            val csLivenessConfig = CSLivenessConfig(
                vocalGuidance = vocalGuidance ?: false, colors = CSLivenessConfigColors(
                    primaryColor = if (!primaryColor.isNullOrBlank()) Color.parseColor(
                        primaryColor
                    ) else null,
                    secondaryColor = if (!secondaryColor.isNullOrBlank()) Color.parseColor(
                        secondaryColor
                    ) else null,
                    titleColor = if (!titleColor.isNullOrBlank()) Color.parseColor(titleColor) else null,
                    paragraphColor = if (!paragraphColor.isNullOrBlank()) Color.parseColor(
                        paragraphColor
                    ) else null
                )
            )

            lateinit var csLiveness : CSLiveness;

            if (!accessToken.isNullOrBlank() && !transactionId.isNullOrBlank()) {
                csLiveness = CSLiveness(transactionId, accessToken, csLivenessConfig)
            } else if (!clientId.isNullOrBlank() && !clientSecretId.isNullOrBlank()) {
                csLiveness = CSLiveness(clientId, clientSecretId, identifierId, cpf, csLivenessConfig)
            } else {
                throw Exception("transactionId and accessToken or clientId and clientSecretId are required")
            }

            if (activity?.application != null) {
                val intent = Intent(context, CSLivenessActivity::class.java)
                intent.putExtra(parameterName, csLiveness)

                activity!!.startActivityForResult(intent, requestCode, null)
            } else {
                throw Exception("Missing application from current activity")
            }
        } catch (t: Throwable) {
            Log.e(logTag, "Error starting CSLivenessSDK", t)

            flutterResult!!.error("InternalError", t.message ?: "InternalError", null)
            this.resetResult()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == this.requestCode) {
            val responseMap = HashMap<String, Any?>()

            try {
                if (resultCode != Activity.RESULT_OK || data == null) {
                    throw Exception("UserCancel")
                }

                val csLivenessResult =
                    data.getSerializableExtra(parameterName) as CSLivenessResult

                responseMap["real"] = csLivenessResult.responseMessage.compareTo("real", true) == 0
                responseMap["responseMessage"] = csLivenessResult.responseMessage
                responseMap["sessionId"] = csLivenessResult.sessionId
                responseMap["image"] = csLivenessResult.image

                Log.d(logTag, "Result: $responseMap")

                if (responseMap["real"] != true) {
                    val responseMessage: String? = responseMap["responseMessage"] as? String

                    throw Exception(responseMessage ?: "UnknownInternalError")
                } else {
                    flutterResult!!.success(responseMap)
                }
            } catch (t: Throwable) {
                Log.e(logTag, t.message ?: "An error occurred")

                flutterResult?.error("SDKError", t.message ?: "InternalError", t)
            }

            resetResult()

            return true
        }

        return false
    }
}
