import Foundation
import SwiftyJSON
import SocketIO
import UIKit

class Helper {
    
    ///////////////////////////////
    //Global variables
    ////////////////////////////////
    static var manager: SocketManager!
    static var socket: SocketIOClient!
    
    static var loggedInUser: User?
    static var downloadedWorld: World?
    static var server = Server()
    static var selectedSceneID:String?
    
    struct User {
        var id: String
        var location: [Float]
        var phone_number: String
        var country_code: Int
        var first_name: String
        var last_name: String
        var __v: String
        var createdAt: String
        var lastTimeLocationUpdated: String
        var sceneId: String
        var nonAppUsers: [String]
        var friends: [String]
        var voipToken : String
        var crashing : [String]
        var loginSecret : String
        var loginToken : String
    }
    
    struct Friend {
        var id: String
        var phone_number: String
        var country_code: Int
        var first_name: String
        var last_name: String
        var sceneId: String
    }
    
    
    struct World {
        var id: String
        var first_name: String
        var last_name: String
        var phone_number: String
        var country_code: Int
        var sceneId: String
        var friends: [Friend]
    }
    
    struct Server {
        
        enum AppEnvMode: String {
            case development = "development"
            case production = "production"
            case none = ""
        }
        
        var serverEnv: String {
            guard let infoPlist = Bundle.main.infoDictionary, let serverEnv = infoPlist["ServerEnv"] as? String else { return "" }
            return serverEnv
        }
        
        var appEnvMode: AppEnvMode {
            guard let infoPlist = Bundle.main.infoDictionary, let serverEnv = infoPlist["AppEnvMode"] as? String,
                let value = AppEnvMode(rawValue: serverEnv) else { return .none }
            
            return value
        }
        
        func log(_ message: String) {
            NetworkService.standard.request(target: .log(message: message), success: { (data) in
                let json = JSON(data as Any)
                print(json)
            }, error: { (error) in
                print(error)
            }) { (failure) in
                print(failure)
            }
        }
        
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


//
//extension Helper.Friend:Decodable {
//    enum FriendCodingKeys: String, CodingKey {
//        case id = "_id"
//        case phone_number
//        case country_code
//        case first_name
//        case last_name
//        case sceneId
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: FriendCodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        phone_number = try container.decode(String.self, forKey: .phone_number)
//        country_code = try container.decode(Int.self, forKey: .country_code)
//        first_name = try container.decode(String.self, forKey: .first_name)
//        last_name = try container.decode(String.self, forKey: .last_name)
//        sceneId = try container.decode(String.self, forKey: .sceneId)
//    }
//}
//
//extension Helper.World:Decodable {
//    enum WorldCodingKeys: String, CodingKey {
//        case id = "_id"
//        case first_name
//        case last_name
//        case phone_number
//        case country_code
//        case sceneId
//        case friends
//    }
//    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: WorldCodingKeys.self)
//        
//        id = try container.decode(String.self, forKey: .id)
//        first_name = try container.decode(String.self, forKey: .first_name)
//        last_name = try container.decode(String.self, forKey: .last_name)
//        phone_number = try container.decode(String.self, forKey: .phone_number)
//        country_code = try container.decode(Int.self, forKey: .country_code)
//        sceneId = try container.decode(String.self, forKey: .sceneId)
//        friends = try container.decode([Helper.Friend].self, forKey: .friends)
//    }
//}
