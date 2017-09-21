
import Foundation

class AppVersion {
    private(set) var must_update:Bool = false
    private(set) var suggest_update:Bool = false
    private(set) var update_message:String = ""

    fileprivate let clientVersion:String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    /***********
     Please finish this init function

     You can find response sample from success.json / fail.json
     parse path is data -> app_version -> ios

     must_update is the bool value of must_update
     update_message is the string value of update_message
     suggest_update is a bool value from comparesion:
     If current_version is bigger than clientVersion, set suggest_update to true, otherwise false
     **********/

    init?(json:[String:Any]?){
        return nil
    }
}
