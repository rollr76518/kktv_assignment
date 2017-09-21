
import Foundation

protocol ServiceStatusDelegate:class{
    func endSuccess()
    func endFailure()
    
    func showVersionForceUpdateAlert(message:String)
    func showVersionSuggestUpdateAlert(message:String)
}

class ServiceStatusHandler {
    weak var delegate:ServiceStatusDelegate?

    /*******
     finish this function by handling response
     MUST cover all ServiceStatusDelegate function
     MUST retry if not reach retry count. Hint:retryOrFail
     *******/

    func start(apiHandler:ServiceStatusAPIDelegate = ServiceStatusAPI()){

        apiHandler.fetchServiceStatus() { ( version,json, error) -> Void in

//            self.delegate?.endSuccess()
//            self.delegate?.endFailure()
//            self.delegate?.showVersionForceUpdateAlert(message: "")
//            self.delegate?.showVersionSuggestUpdateAlert(message: "")
        }
    }

    private func retryOrFail( apiHandler:ServiceStatusAPIDelegate,json:[String:Any]?,error:NSError?) {
        var apiHandler = apiHandler
        if apiHandler.retryStatus == .reachMax {
            self.delegate?.endFailure()
        } else {
            apiHandler.retryCount += 1
            self.start(apiHandler:apiHandler )
        }
    }
}
