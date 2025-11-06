import Foundation

@MainActor
class DitoIdentify {

    private let service: DitoIdentifyService
    private let identifyOffline: DitoIdentifyOffline

    init(service: DitoIdentifyService = .init(), identifyOffline: DitoIdentifyOffline = .init()) {
        self.service = service
        self.identifyOffline = identifyOffline
    }

    func identify(id: String, data: DitoUser? = nil, sha1Signature: String? = nil) {

        // Compute the default on the main actor before hopping to a background queue
        let resolvedSignature: String = sha1Signature ?? Dito.signature
        let apiKey = Dito.apiKey

        DispatchQueue.global().async { [resolvedSignature, apiKey] in

            // Hop to the main actor to access main-actor isolated state
            Task { @MainActor in
                self.identifyOffline.initiateIdentify()

                let signupRequest = DitoSignupRequest(
                    platformApiKey: apiKey,
                    sha1Signature: resolvedSignature,
                    userData: data
                )

                guard data?.email != nil else {
                    self.identifyOffline.finishIdentify()
                    return
                }

                // Call service from the main actor since `service` is also main-actor isolated
                self.service.signup(network: "portal", id: id, data: signupRequest) { (identify, error) in
                    Task { @MainActor in
                        if let error = error {
                            self.identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                            DitoLogger.error(error.localizedDescription)
                        } else {
                            if let reference = identify?.reference {
                                self.identifyOffline.identify(id: id, params: signupRequest, reference: reference, send: true)
                                DitoLogger.information("Identify realizado")
                            } else {
                                self.identifyOffline.identify(id: id, params: signupRequest, reference: nil, send: false)
                            }
                        }
                        self.identifyOffline.finishIdentify()
                    }
                }
            }
        }
    }
}
