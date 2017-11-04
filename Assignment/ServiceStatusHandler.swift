
import Foundation

protocol ServiceStatusDelegate: class {
    func endSuccess()
    func endFailure()
    
    func showVersionForceUpdateAlert(message: String)
    func showVersionSuggestUpdateAlert(message: String)
}

class ServiceStatusHandler {
    weak var delegate: ServiceStatusDelegate?

    /*******
     finish this function by handling response
     MUST cover all ServiceStatusDelegate function
     MUST retry if not reach retry count. Hint:retryOrFail
     *******/

    func start(apiHandler: ServiceStatusAPIDelegate = ServiceStatusAPI()){

        apiHandler.fetchServiceStatus() { (version, json, error) -> Void in
            guard let delegate = self.delegate else { return }

            if let _ = error {
                self.retryOrFail(apiHandler: apiHandler, json: json, error: error)
            }
            else {
                delegate.endSuccess()
                
                if let version = version {
                    if version.must_update {
                        delegate.showVersionForceUpdateAlert(message: version.update_message)
                    }
                    if version.suggest_update {
                        delegate.showVersionSuggestUpdateAlert(message: version.update_message)
                    }
                }
            }
        }
    }

    private func retryOrFail(apiHandler: ServiceStatusAPIDelegate, json: [String: Any]?, error: NSError?) {
        guard let delegate = self.delegate else { return }

        var apiHandler = apiHandler
        if apiHandler.retryStatus == .reachMax {
            delegate.endFailure()
        } else {
            apiHandler.retryCount += 1
            self.start(apiHandler: apiHandler )
        }
    }
}
