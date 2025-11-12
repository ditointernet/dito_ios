import Foundation

class DitoIdentify {

  private let service: DitoIdentifyService
  private let identifyOffline: DitoIdentifyOffline
  private let retry: DitoRetry

  init(
    service: DitoIdentifyService = .init(),
    identifyOffline: DitoIdentifyOffline = .shared,
    retry: DitoRetry = .init()
  ) {
    self.service = service
    self.identifyOffline = identifyOffline
    self.retry = retry
  }

  func identify(
    id: String,
    data: DitoUser? = nil,
    sha1Signature: String? = nil
  ) {

    // Compute the default on the main actor (class is @MainActor)
    let resolvedSignature: String = sha1Signature ?? Dito.signature
    let apiKey = Dito.apiKey

    // Proceed on the main actor; service callbacks are also delivered on main
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

    self.service.signup(network: "portal", id: id, data: signupRequest) {
      (identify, error) in
      if let error = error {
        self.identifyOffline.identify(
          id: id,
          params: signupRequest,
          reference: nil,
          send: false
        )
        DitoLogger.error(error.localizedDescription)
      } else {
        if let reference = identify?.reference {
          self.identifyOffline.identify(
            id: id,
            params: signupRequest,
            reference: reference,
            send: true
          )
          DitoLogger.information("Identify realizado")
          self.retry.loadOffline()
        } else {
          self.identifyOffline.identify(
            id: id,
            params: signupRequest,
            reference: nil,
            send: false
          )
        }
      }
      self.identifyOffline.finishIdentify()
    }
  }
}
