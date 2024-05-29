import Flutter
import UIKit
import CSLivenessSDK

extension UIColor {
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init("ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

public class LivenessFlutterSdkPlugin: NSObject, FlutterPlugin {
    
    private let LOG_TAG = "[CSLivenessFlutter]"
    private var flutterResult: FlutterResult?;
    
    private func resetFlutterResult() -> Void {
        self.flutterResult = nil
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "liveness_flutter_sdk", binaryMessenger: registrar.messenger())
        let instance = LivenessFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "openCSLiveness":
            if let arguments = call.arguments as? [String:Any] {
                let sdkParams: NSDictionary = [
                    "clientId": arguments["clientId"] as! String,
                    "clientSecretId": arguments["clientSecretId"] as! String,
                    "identifierId": arguments["identifierId"] as? String,
                    "cpf": arguments["cpf"] as? String,
                    "vocalGuidance": arguments["vocalGuidance"] as! Bool,
                    "primaryColor": arguments["primaryColor"] as! String,
                    "secondaryColor": arguments["secondaryColor"] as! String,
                    "titleColor": arguments["titleColor"] as! String,
                    "paragraphColor": arguments["paragraphColor"] as! String
                ];
                
                openCSLiveness(sdkParams: sdkParams, resultParam: result)
            } else {
                result(FlutterError(code: "MissingSdkParams", message: "Unable to get sdk params from payload", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func openCSLiveness(sdkParams: NSDictionary, resultParam: @escaping FlutterResult) {
        if self.flutterResult != nil {
            // Means that we are already running and somehow the button got triggered again.
            // In this case just return.
            
            return
        }
        
        if let clientId = sdkParams["clientId"] as? String, let clientSecretId = sdkParams["clientSecretId"] as? String, let vocalGuidance = sdkParams["vocalGuidance"] as? Bool {
            
            self.flutterResult = resultParam
            
            DispatchQueue.main.async {
                let primaryColor = sdkParams["primaryColor"] != nil ? UIColor(sdkParams["primaryColor"] as! String) : nil;
                let secondaryColor = sdkParams["secondaryColor"] != nil ? UIColor(sdkParams["secondaryColor"] as! String) : nil;
                let tertiaryColor = sdkParams["tertiaryColor"] != nil ? UIColor(sdkParams["tertiaryColor"] as! String) : nil;
                let titleColor = sdkParams["titleColor"] != nil ? UIColor(sdkParams["titleColor"] as! String) : nil;
                let paragraphColor = sdkParams["paragraphColor"] != nil ? UIColor(sdkParams["paragraphColor"] as! String) : nil;
                
                let identifierId = sdkParams["identifierId"] as? String ?? ""
                let cpf = sdkParams["cpf"] as? String ?? ""
                
                let livenessConfiguration = CSLivenessConfig(clientId: clientId, clientSecret: clientSecretId, identifierId: "", cpf: "", colors: CSLivenessColorsConfig(primaryColor: primaryColor, secondaryColor: secondaryColor, titleColor: titleColor, paragraphColor: paragraphColor))
                
                if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                    let sdk = CSLiveness(configuration: livenessConfiguration, vocalGuidance: vocalGuidance)
                    sdk?.delegate = self
                    sdk?.start(viewController: viewController, animated: true)
                } else {
                    resultParam(FlutterError(code: "ViewControllerMissing", message: "Unable to find view controller", details: nil))
                }
            }
        } else {
            resultParam(FlutterError(code: "MissingParameters", message: "Missing clientId, clientSecretId or both", details: nil))
        }
    }
    
}

extension LivenessFlutterSdkPlugin: CSLivenessDelegate {
    public func liveness(didOpen: Bool) {
        NSLog("\(LOG_TAG) - called didOpen")
    }
    
    public func liveness(success: CSLivenessResult) {
        NSLog("\(LOG_TAG) - called didFinishCapture")
        
        let responseMap = NSMutableDictionary();
        responseMap.setValue(success.real, forKey: "real")
        responseMap.setValue(success.sessionId, forKey: "sessionId")
        responseMap.setValue(success.image, forKey: "image")
        
        if let result = self.flutterResult {
            result(responseMap)
        }
        
        self.resetFlutterResult()
    }
    
    public func liveness(error: CSLivenessError) {
        NSLog("\(LOG_TAG) - called didReceiveError")

        if let result = self.flutterResult {
            result(FlutterError(code: String(error.localizedDescription), message: String(error.rawValue), details: nil))
        }
        
        self.resetFlutterResult()
    }
}
