
import Foundation

class APISample {
    func sendRequest() {
        let sessionConfig = URLSessionConfiguration.default

        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        guard let URL = URL(string: "https://test-api-ng.kktv.com.tw/v0/service_status") else {
            return
        }

        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}
