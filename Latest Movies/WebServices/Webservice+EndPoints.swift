//
//  Webservice+EndPoints.swift
//  StarterProj
//
//  Created by Gurdeep on 06/03/17.
//  Copyright © 2017 Gurdeep. All rights reserved.
//

import Foundation

let baseUrl = "https://api.themoviedb.org/3/movie/"
let imgaeBaseIrl = "http://image.tmdb.org/t/p/w185"
let trailerBaseUrl = "https://www.youtube.com/watch?v="

extension WebServices {
    
    enum EndPoint : String {
        
        case popularMovie = "popular"
        
        var path : String {
            
            let url = baseUrl
            return url + self.rawValue
        }
    }
}
