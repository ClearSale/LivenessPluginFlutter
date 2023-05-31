import CSLivenessSDK

typealias CSLivenessSuccess = ((String) -> Void)
typealias CSLivenessError = ((String) -> Void)
class CSLivenessManager: NSObject {
    let success: CSLivenessSuccess;
    let error: CSLivenessError;
    private var livenessSdk: CSLiveness!
    init(clientId: String, clientSecret: String, vocalGuidance: Bool,
                  success: @escaping CSLivenessSuccess,
                  error:@escaping  CSLivenessError) {
        self.success = success
        self.error = error
        super.init()
        self.start(clientId: clientId, clientSecret: clientSecret, vocalGuidance: vocalGuidance)
    }

    private func start(clientId:String, clientSecret:String, vocalGuidance:Bool) {
        force(portrait: true)
        DispatchQueue.main.async {
            self.livenessSdk = CSLiveness(
                configurations: CSLivenessConfigurations(
                  clientId: self.clientId,
                  clientSecret: self.clientSecret,
                ),
                vocalGuidance: self.vocalGuidance
            )
            self.livenessSdk.delegate = self
            self.livenessSdk.start(viewController: self, animated: true)
        }
    }

    func force(portrait: Bool) {
        DispatchQueue.main.async {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.lockOrientationToPortrait = portrait
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
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
