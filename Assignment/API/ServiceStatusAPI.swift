
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
        
        let sessionConfig = URLSessionConfiguration.default
        
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        
        guard let URL = URL(string: "https://test-api-ng.kktv.com.tw/v0/service_status") else {
            return
        }
        
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in            
            if let error = error {
                // Failure
                print("URL Session Task Failed: %@", error.localizedDescription);
                callback(nil, nil, error as NSError)
            }
            else {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                
                if let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                    let appVersion = AppVersion.init(json: json)
                    callback(appVersion, json, nil)
                }
            }
        })
        
        task.taskDescription = FetchServiceStatus

        cancelRequest(identifier: FetchServiceStatus, callback: nil)
        
        task.resume()
        session.finishTasksAndInvalidate()
    }

    private func cancelRequest(identifier: String, callback: (()->Void)?) {

        self.session.getTasksWithCompletionHandler({ (dataTask, uploadTask, downloadTask) -> Void in

            let allTasks = NSArray(array: dataTask)
            allTasks.addingObjects(from: uploadTask)
            allTasks.addingObjects(from: downloadTask)

            if let allTasks = allTasks as? [URLSessionDataTask] {
                for task in allTasks {
                    if task.taskDescription == identifier {
                        task.cancel()
                    }
                }
            }

            if let callback = callback {
                callback()
            }
        })
    }
}
