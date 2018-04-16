////
////  UsersClient.swift
////  buckets
////
////  Created by Muhand Jumah on 4/13/18.
////  Copyright © 2018 Muhand Jumah. All rights reserved.
////
//
//import UIKit
//import Moya
//
//struct User {
//    let id: String
//    let location: [Int]
//    let phone_number: String
//    let country_code: Int
//    let first_name: String
//    let last_name: String
//    let __v: String
//    let createdAt: String
//    let lastTimeLocationUpdated: String
//    let sceneId: String
//    let nonAppUsers: [User]
//    let friends: [String]
//
//}
//
//extension User:Decodable {
//    enum UsersCodingKeys: String, CodingKey {
//        case id = "_id"
//        case location
//        case phone_number
//        case country_code
//        case first_name
//        case last_name
//        case __v
//        case createdAt
//        case lastTimeLocationUpated
//        case sceneId
//        case nonAppUsers
//        case friends
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: UsersCodingKeys.self)
//
//        id = try container.decode(String.self, forKey: .id)
//        location = try container.decode([Int].self, forKey: .location)
//        phone_number = try container.decode(String.self, forKey: .phone_number)
//        country_code = try container.decode(Int.self, forKey: .country_code)
//        first_name = try container.decode(String.self, forKey: .first_name)
//        last_name = try container.decode(String.self, forKey: .last_name)
//        __v = try container.decode(String.self, forKey: .__v)
//        createdAt = try container.decode(String.self, forKey: .createdAt)
//        lastTimeLocationUpdated = try container.decode(String.self, forKey: .lastTimeLocationUpated)
//        sceneId = try container.decode(String.self, forKey: .sceneId)
//        nonAppUsers = try container.decode([User].self, forKey: .nonAppUsers)
//        friends = try container.decode([String].self, forKey: .friends)
//
//
//    }
//}
//
//struct UserResults {
//    let users: [User]
//}
//
//extension UserResults: Decodable {
//    private enum ResultsCodingKeys: String, CodingKey {
//        case users
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: ResultsCodingKeys.self)
//
//        users = try container.decode([User].self, forKey: .users)
//    }
//}
//
//enum UsersApi {
//    case users(users:[User])
//}
//
//extension UsersApi: TargetType {
//    var headers: [String : String]? {
//        return nil
//    }
//
//    var path: String {
//        switch self {
//            case .users:
//                return "/users"
//        }
//    }
//
//    var method: Moya.Method {
//        switch self {
//            case .users:
//                return .get
//        }
//    }
//
//    var sampleData: Data {
//        return Data()
//    }
//
//    var task: Task {
//        return .requestPlain
//    }
//
//    var enviornmentBaseURL : String {
//        switch NetworkManager.enviornment {
//            case .production: return "127.0.0.1/v1/"
//            case .qa: return "127.0.0.1/v1/"
//            case .staging: return "127.0.0.1/v1/"
//        }
//    }
//
//    var baseURL: URL {
//        guard let url = URL(string:enviornmentBaseURL) else { fatalError("baseURL couldn't be configured")}
//        return url
//    }
//}
//
//enum APIEnviornment {
//    case staging
//    case qa
//    case production
//}
//
//struct NetworkManager {
//    fileprivate let provider = MoyaProvider<UsersApi>(plugins: [NetworkLoggerPlugin(verbose:true)])
//    static let enviornment: APIEnviornment = .production
//}
//
//extension UsersApi {
//    var sampleData: Data {
//        switch self {
//            case .users:
//                return stubbedResponse("Users")
//        }
//    }
//}
//
//func stubbedResponse(_ filename: String) -> Data! {
//    @objc class TestClass: NSObject { }
//
//    let bundle = Bundle(for: TestClass.self)
//    let path = bundle.path(forResource: filename, ofType: "json")
//    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
//}
//
//class UsersClient: NSObject {
////    func fetchUsers(completion: ([NSDictionary]?) -> ()) {
////        // Fetch the users
////        let session = NSURLsession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
////        // Call the completion block
////    }
//}





import Foundation
import Moya
import SwiftyJSON

//guard let infoPlist = Bundle.main.infoDictionary, let serverEnv = infoPlist["ServerEnv"] as? String else { return "" }

struct CrashURL {
    static var baseURL = Helper.server.serverEnv
    static var version = "v1"
}

enum CrashAPI {
    case auth(body: [String: Any])
    case check(body: [String: Any])
    case register(body: [String: Any])
    case updateUser(phone: Int, body: [String: Any])
    case zenly(id: String)
    case world(security: String)
    case user(id: String)
    case refreshWorld
    case log(message: String)
    case scenesForUser(id: String)
    case crash(sceneId: String)
    case users
}

extension CrashAPI: TargetType {
    var baseURL: URL {
        return URL(string: "\(CrashURL.baseURL)\(CrashURL.version)")!
    }
    
    var path: String {
        switch self {
        case .auth:
            return "/auth"
        case .check:
            return "/auth/check"
        case .register:
            return "/users/register"
        case .world(let security):
            return "/world"
        case .updateUser(let phone, _):
            return "/users/by-phone/\(phone)"
        case .zenly:
            return "/push/zenly"
        case .refreshWorld:
            return "/world/update"
        case .log:
            return "/logs"
        case .scenesForUser(let id):
            return "/scenes/for-user/\(id)"
        case .user(let id):
            return "/users/by-id/\(id)"
        case .crash(let sceneId):
            return "/scenes/crash/\(sceneId)"
        case .users:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .auth, .check, .register, .zenly, .log, .crash:
            return .post
        case .world, .refreshWorld, .scenesForUser, .user, .users:
            return .get
        case .updateUser:
            return .patch
        }
    }
    
    var task: Task {
        switch self {
            case .auth(let body):
                guard let phoneNumber = body["phone_number"] as? Int else { return .requestPlain }
                guard let countryCode = body["country_code"] as? Int else { return .requestPlain }
                let params = ["phone_number": phoneNumber, "country_code": countryCode]
                return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .register(let body):
                return .requestParameters(parameters: body, encoding: JSONEncoding.default) // TODO: Finish this URL task
            case .check(let body):
                return .requestParameters(parameters: body, encoding: JSONEncoding.default)
            case .updateUser(_, let body):
                return .requestParameters(parameters: body, encoding: JSONEncoding.default)
            case .zenly(let id):
                let body = ["id": id]
                return .requestParameters(parameters: body, encoding: JSONEncoding.default)
            case .log(let message):
                let body = ["message": message]
                return .requestParameters(parameters: body, encoding: JSONEncoding.default)
            default:
                return .requestPlain
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]? {
        
        var header = Dictionary<String, String>()

        switch self {
        case .updateUser, .refreshWorld, .log, .scenesForUser, .crash:
            return header
        case .user(let id):
             header["Security"] = id
             return header
        case .world(let security):
            header["Security"] = security
            return header
        default:
            return nil
        }
    }
}
