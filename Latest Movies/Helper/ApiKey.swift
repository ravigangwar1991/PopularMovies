//
//  ApiKey.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation

//MARK:- Api Keys
//=======================
enum ApiKey {
    
    static var status: String { return "status" }
    static var code: String { return "CODE" }
    static var id: String { return "id" }
    static var poster_path: String { return "poster_path" }
    static var title: String { return "title" }
    static var results: String { return "results" }
    static var release_date: String { return "release_date" }
    static var overview: String { return "overview" }
    static var genres: String { return "genres" }
    static var name: String { return "name" }
    static var api_key: String { return "api_key" }
    static var page: String { return "page" }
    static var total_pages: String { return "total_pages" }
    static var type: String { return "type" }
    static var key: String { return "key" }
    
}

//MARK:- Api Code
//=======================
enum ApiCode {
    
    static var success: Int { return 200 } // Success
    static var unauthorizedRequest: Int { return 206 } // Unauthorized request
    static var headerMissing: Int { return 207 } // Header is missing
    static var phoneNumberAlreadyExist: Int { return 208 } // Phone number alredy exists
    static var requiredParametersMissing: Int { return 418 } // Required Parameter Missing or Invalid
    static var fileUploadFailed: Int { return 421 } // File Upload Failed
    static var pleaseTryAgain: Int { return 500 } // Please try again
    static var tokenExpired: Int { return 401 } // Token expired refresh token needed to be generated
}
