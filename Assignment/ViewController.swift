
import UIKit

/*******
 You don't need to do anything in this class.
 You can use this class for verify ServiceStatusDelegate handling
 *******/

class ViewController: UIViewController {

    fileprivate let handler = ServiceStatusHandler()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.handler.delegate = self
        self.handler.start()
    }
}

extension ViewController:ServiceStatusDelegate {
    func endSuccess() {
        print("endSuccess")
    }

    func endFailure() {
        print("endFailure")
    }

    func showVersionForceUpdateAlert(message: String) {
        print("showVersionForceUpdateAlert \(message)")
    }

    func showVersionSuggestUpdateAlert(message: String) {
        print("showVersionSuggestUpdateAlert \(message)")
    }
}

