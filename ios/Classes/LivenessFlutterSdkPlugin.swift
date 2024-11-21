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
    private var sdk: CSLiveness?;
    
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
                    "accessToken": arguments["accessToken"] as? String,
                    "transactionId": arguments["transactionId"] as? String,
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
        
        let accessToken = sdkParams["accessToken"] as? String
        let transactionId = sdkParams["transactionId"] as? String

        let vocalGuidance = sdkParams["vocalGuidance"] as? Bool ?? false
        
        // Colors configuration
        let primaryColor = sdkParams["primaryColor"] != nil ? UIColor(sdkParams["primaryColor"] as! String) : nil;
        let secondaryColor = sdkParams["secondaryColor"] != nil ? UIColor(sdkParams["secondaryColor"] as! String) : nil;
        let titleColor = sdkParams["titleColor"] != nil ? UIColor(sdkParams["titleColor"] as! String) : nil;
        let paragraphColor = sdkParams["paragraphColor"] != nil ? UIColor(sdkParams["paragraphColor"] as! String) : nil;
        
        let colorsConfiguration = CSLivenessColorsConfig(primaryColor: primaryColor, secondaryColor: secondaryColor, titleColor: titleColor, paragraphColor: paragraphColor)
        
        
        self.flutterResult = resultParam

        if accessToken != nil && transactionId != nil {
            self.sdk = CSLiveness(configuration: CSLivenessConfig(accessToken: accessToken!, transactionId: transactionId!, colors: colorsConfiguration), vocalGuidance: vocalGuidance)
        } else {
            resultParam(FlutterError(code: "NoConstructorFound", message: "Unable to find viable constructor for SDK", details: nil))
            
            self.resetFlutterResult()
            return
        }
        
        
        DispatchQueue.main.async {
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                self.sdk?.delegate = self
                self.sdk?.start(viewController: viewController, animated: true)
            } else {
                resultParam(FlutterError(code: "ViewControllerMissing", message: "Unable to find view controller", details: nil))
                
                self.resetFlutterResult()
            }
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
