//
//  NetworkService.swift
//  buckets
//
//  Created by Muhand Jumah on 4/14/18.
//  Copyright © 2018 Muhand Jumah. All rights reserved.
//

import Foundation
import Moya

class NetworkService {
    
    static let standard = NetworkService()
    
    private let provider = MoyaProvider<CrashAPI>()
    
    private init() {}
    
    func request(
        target: CrashAPI,
        success successCallback: @escaping (Any?) -> Void,
        error errorCallback: @escaping (_ statusCode: Response) -> Void,
        failure failureCallback: @escaping (Moya.MoyaError) -> Void
        ) {
        
        provider.request(target, completion: { result in
            switch result {
            case let .success(response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let json = try? response.mapJSON()
                    successCallback(json)
                } catch {
                    errorCallback(response)
                }
            case let .failure(error):
                
                failureCallback(error)
            }
            
        })
    }
}
