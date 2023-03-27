import CSLivenessSDK

typealias CSLivenessSuccess = ((String) -> Void)
typealias CSLivenessError = ((String) -> Void)
class CSLivenessManager: NSObject {
    let success: CSLivenessSuccess;
    let error: CSLivenessError;
    private var livenessSdk: CSLiveness?
    init(clientId: String, clientSecret: String, vocalGuidance: Bool,
                  success: @escaping CSLivenessSuccess,
                  error:@escaping  CSLivenessError) {
        self.success = success
        self.error = error
        super.init()
        self.start(clientId: clientId, clientSecret: clientSecret, vocalGuidance: vocalGuidance)
    }

    private func start(clientId:String, clientSecret:String, vocalGuidance:Bool) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2 ){
            DispatchQueue.main.async {[weak self] in
                if let self = self {
                    self.livenessSdk = CSLiveness(
                        configurations: CSLivenessConfigurations(
                            clientId: clientId as String,
                            clientSecret: clientSecret  as String
                        ),
                        vocalGuidance: vocalGuidance as Bool
                    )
                    let viewController = UIApplication.shared.keyWindow?.rootViewController
                    if let viewController = viewController {
                        self.livenessSdk?.delegate = self
                        self.livenessSdk?.start(viewController: viewController, animated: true);
                    }else {
                        //error
                        self.error("userCancel: ViewController not founded.")
                    }
                }
            }
        }
    }

}

// MARK: - CSLivenessDelegate
extension CSLivenessManager: CSLivenessDelegate{
    func liveness(didOpen: Bool) {}

    func liveness(error: CSLivenessSDK.CSLivenessError) {
        self.error(error.rawValue)
    }

    func liveness(success: CSLivenessSDK.CSLivenessResult) {
        let result =
               """
                   {
                       "real":\(success.real),
                       "sessionId":"\(success.sessionId)",
                       "image": "\(success.image)"
                   }
               """
        self.success(result.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
