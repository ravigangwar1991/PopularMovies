//
//  AppNetworking.swift
//  StarterProj
//
//  Created by Gurdeep on 16/12/16.
//  Copyright © 2016 Gurdeep. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias JSONDictionary = [String : Any]
typealias JSONDictionaryArray = [JSONDictionary]
typealias HTTPHeaders = [String:String]
typealias SuccessResponse = (_ json : JSON) -> ()
typealias FailureResponse = (Error) -> (Void)
typealias ResponseMessage = (_ message : String) -> ()
typealias DownloadData = (_ data : Data) -> ()
typealias UploadFileParameter = (fileName: String, key: String, data: Data, mimeType: String)

extension Notification.Name {
    static let NotConnectedToInternet = Notification.Name("NotConnectedToInternet")
}

enum AppNetworking {
    
    static var timeOutInterval = TimeInterval(30)
    
    private static func executeRequest(_ request: NSMutableURLRequest, _ success: @escaping (JSON) -> Void, _ failure: @escaping (Error) -> Void) {
        let session = URLSession.shared
        
        session.configuration.timeoutIntervalForRequest = timeOutInterval
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
            if (error == nil) {
                
                do {
                    if let jsonData = data {
                        
                        if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                            
                            print(jsonDataDict)
                            DispatchQueue.main.async(execute: { () -> Void in
                                
                                success(JSON(jsonDataDict))
                            })
                        }
                        
                    }else{
                        let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"No data found"])
                        failure(error)
                    }
                } catch let err as NSError {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    print("responseString = \(responseString ?? "")")
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure(err)
                    })
                }
            } else {
                if let httpResponse = response as? HTTPURLResponse {
                    print(httpResponse)
                }
                if let err = error {
                    DispatchQueue.main.async(execute: { () -> Void in
                        failure(err)
                    })
                }else{
                    let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Something went wrong"])
                    failure(error)
                }
            }
        })
        
        dataTask.resume()
    }
    
    private static func REQUEST(withUrl url : URL?,method : String,success : @escaping (JSON) -> Void, failure : @escaping (Error) -> Void) {
        
        guard let url = url else {
            let error = NSError.init(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey:"Url or parameters not valid"])
            failure(error)
            return
        }
        
        let request = NSMutableURLRequest(url: url,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = method
        executeRequest(request, success, failure)
    }
    
    static func GET(endPoint : String,
                    parameters : [String : Any] = [:],
                    success : @escaping (JSON) -> Void,
                    failure : @escaping (Error) -> Void) {
        
        
        print("============ \n Parameters are =======> \n\n \(parameters) \n =================")
        
        guard let urlString = (endPoint + "?" + encodeParamaters(params: parameters)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else{
            return
        }
        
        print("============ \n urlString are =======> \n\n \(urlString) \n =================")

        
        let uri = URL(string: urlString)
        
        REQUEST(withUrl: uri,
                method: "GET",
                success: success,
                failure: failure)
        
    }
    
    
    static private func encodeParamaters(params : [String : Any]) -> String {
        
        var result = ""
        
        for key in params.keys {
            
            result.append(key+"=\(params[key] ?? "")&")
        }
        
        if !result.isEmpty {
            result.remove(at: result.index(before: result.endIndex))
        }
        
        return result
    }

}


extension Data {
    
    /// Append string to NSMutableData
    ///
    /// Rather than littering my code with calls to `dataUsingEncoding` to convert strings to NSData, and then add that data to the NSMutableData, this wraps it in a nice convenient little extension to NSMutableData. This converts using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `NSMutableData`.
    
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
