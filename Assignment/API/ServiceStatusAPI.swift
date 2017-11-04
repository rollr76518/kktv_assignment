
import Foundation

enum RetryStatus {
    case canTryAgain
    case reachMax
}

typealias StatusAPICompletion = (AppVersion?, [String: Any]?, NSError?) -> Void

protocol ServiceStatusAPIDelegate {
    var retryCount: Int {set get}
    var retryStatus: RetryStatus { get }
    func fetchServiceStatus(callback: @escaping StatusAPICompletion)
}

let ServiceStatusAPIDomain = "ServiceStatusAPIDomain"
let FetchServiceStatus = "FetchServiceStatus"

class ServiceStatusAPI: ServiceStatusAPIDelegate {

    private let retryMax: Int
    var retryCount: Int

    private let session: URLSession
    private let operationQueue: OperationQueue

    var retryStatus: RetryStatus {
        if retryCount >= retryMax {
            return .reachMax
        } else {
            return .canTryAgain
        }
    }

    init(max: Int = 3) {
        self.retryMax = max
        self.retryCount = 0

        let sessionConfig = URLSessionConfiguration.ephemeral
        sessionConfig.timeoutIntervalForRequest = 5.0

        self.operationQueue = OperationQueue()
        self.session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: self.operationQueue)
    }

    /**************
     Please finish this function for following requirement
     1. Error handling if this API trigger again before last API call finish. Hint:use cancelRequest
     2. convert API response to AppVersion model
     *************/

    func fetchServiceStatus(callback: @escaping StatusAPICompletion) {
//        let error = NSError(domain: ServiceStatusAPIDomain, code: 0, userInfo: nil)
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "https://test-api-ng.kktv.com.tw/v0/service_status") else {
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            self.retryCount -= 1
            
            if let error = error {
                // Failure
                print("URL Session Task Failed: %@", error.localizedDescription);
                callback(nil, nil, error as NSError)
            }
            else {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
        })
        
        task.taskDescription = FetchServiceStatus

        if retryStatus == .reachMax {
            cancelRequest(identifier: FetchServiceStatus, callback: {
                print("cancelFinished")
            })
        }
        
        retryCount += 1

        task.resume()
        session.finishTasksAndInvalidate()
    }

    private func cancelRequest(identifier: String, callback: (()->Void)?){

        self.session.getTasksWithCompletionHandler({ (dataTask, uploadTask, downloadTask) -> Void in

            let allTasks = NSArray(array: dataTask)
            allTasks.addingObjects(from: uploadTask)
            allTasks.addingObjects(from: downloadTask)

            if allTasks.count > 0{
                for task: URLSessionTask in allTasks as! [URLSessionDataTask]{
                    if task.taskDescription == identifier {
                        self.retryCount -= 1
                        task.cancel()
                    }
                }
            }

            if callback != nil {
                callback!()
            }
        })
    }
}
