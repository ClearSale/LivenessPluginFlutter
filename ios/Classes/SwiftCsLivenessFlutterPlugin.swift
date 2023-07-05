import Flutter
import UIKit

typealias CheckPluginResult = (clientId: String, clientSecret: String, vocalGuidance: Bool, identifierId: String, cpf: String)

public class SwiftCsLivenessFlutterPlugin: NSObject, FlutterPlugin {
    private var livenessManager: CSLivenessManager?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cs_liveness_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftCsLivenessFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if let checkResult = checkPluginRequirements(call, result: result) {
            livenessManager = CSLivenessManager(clientId: checkResult.clientId, clientSecret: checkResult.clientSecret, vocalGuidance: checkResult.vocalGuidance, identifierId: checkResult.identifierId, cpf: checkResult.cpf, success: { success in
                result(success)
            }, error: {error in
                result(FlutterError.init(code: error, message: error, details: error))
            })
        }
    }
}

private func checkPluginRequirements(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> CheckPluginResult? {
    if call.method == "livenessRecognition" {
        if let args = call.arguments as? Dictionary<String, Any>,
           let vocalGuidance = args["vocalGuidance"] as? Bool,
           let clientId = args["clientId"] as? String,
           let identifierId = args["identifierId"] as? String,
           let cpf = args["cpf"] as? String,
           let clientSecret = args["clientSecret"] as? String {

            return CheckPluginResult(clientId,clientSecret,vocalGuidance,identifierId,cpf);
        } else {
            result(FlutterError.init(code: "INVALID_ARGS", message: "Arguments are not valid.", details: "The following arguments, clientId or clientSecret aren't valid."))
        }
    }else {
        result(FlutterError.init(code: "INVALID_METHOD", message: "Method is invalid.", details: "Method \(call.method) not valid."))
    }
    return nil;
}
