//
//  Webservices.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WebServices { }

extension NSError {
    
    convenience init(localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: 0, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
    
    convenience init(code : Int, localizedDescription : String) {
        self.init(domain: "AppNetworkingError", code: code, userInfo: [NSLocalizedDescriptionKey : localizedDescription])
    }
}

extension WebServices{
    
    static func getMovieList(parameters: JSONDictionary,
                               success: @escaping SuccessResponse,
                               failure: @escaping FailureResponse) {
        
        AppNetworking.GET(endPoint: WebServices.EndPoint.popularMovie.path, parameters: parameters, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    static func getMovieDetails(_ id:String,
                             success: @escaping SuccessResponse,
                             failure: @escaping FailureResponse) {
        
        let newUrl = baseUrl + id
        var params = JSONDictionary()
        params[ApiKey.api_key] = AppConstant.Api_Key

        AppNetworking.GET(endPoint: newUrl, parameters: params, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    static func getVideoDetails(_ id:String,
                             success: @escaping SuccessResponse,
                             failure: @escaping FailureResponse) {
        
        let newUrl = baseUrl + id + "/videos"
        var params = JSONDictionary()
        params[ApiKey.api_key] = AppConstant.Api_Key
        
        AppNetworking.GET(endPoint: newUrl, parameters: params, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
}
