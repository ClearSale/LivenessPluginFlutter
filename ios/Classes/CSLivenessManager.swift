import CSLivenessSDK
import Foundation

typealias CSLivenessSuccess = ((String) -> Void)
typealias CSLivenessError = ((String) -> Void)
class CSLivenessManager: NSObject {
    let success: CSLivenessSuccess
    let error: CSLivenessError
    private var livenessSdk: CSLiveness?
    init(clientId: String, clientSecret: String, identifierId: String?, cpf: String?, config: String?,
                  success: @escaping CSLivenessSuccess,
                  error:@escaping  CSLivenessError) {
        self.success = success
        self.error = error
        super.init()
        self.start(clientId: clientId, clientSecret: clientSecret, identifierId: identifierId, cpf: cpf, config: config)
    }

    private func start(clientId:String, clientSecret:String, identifierId:String?, cpf:String?, config:String?) {
        let decoder = JSONDecoder()
        var configuration: Config?
        var csColors: CSLivenessColorsConfig?

        if let c = config {
            do{
                if let cData: Data = c.data(using: .utf8) {
                    configuration = try decoder.decode(Config.self, from: cData)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        
        if let colors = configuration?.colors as? Colors{
            csColors = CSLivenessColorsConfig(
                primaryColor: UIColor(colors.primary ?? ""),
                secondaryColor: UIColor(colors.secondary ?? ""),
                titleColor: UIColor(colors.title ?? ""),
                paragraphColor: UIColor(colors.paragraph ?? "")
            )
        }
        
        let csConfig: CSLivenessConfig = CSLivenessConfig(
                        clientId: clientId,
                        clientSecret: clientSecret,
                        identifierId: identifierId,
                        cpf: cpf,
                        colors: csColors)
        
        self.livenessSdk = CSLiveness(
            configuration: csConfig,
            vocalGuidance: configuration?.vocalGuidance ?? false
        )
        let viewController = UIApplication.shared.keyWindow?.rootViewController
        if let viewController = viewController {
            self.livenessSdk?.delegate = self
            self.livenessSdk?.start(viewController: viewController, animated: true)
        } else {
            self.error("userCancel: ViewController not founded.")
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
