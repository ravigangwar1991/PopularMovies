//
//  MovieDetailsModel.swift
//  Latest Movies
//
//  Created by Ravi on 31/07/19.
//  Copyright © 2019 Ravi. All rights reserved.

import Foundation
import SwiftyJSON
import RealmSwift
import Realm

//MARK:-Model to store Movie Details in Temperary
struct MovieDetailsModel {
    
    var id:String
    var thumbUrl:String
    var title:String
    var release_date:String
    var overview:String
    var genres : String
    var videoId: String = ""
    
    var dateStr:String{
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd"
        guard let date = dateformater.date(from: self.release_date) else {return "NA"}
        dateformater.dateFormat = "dd.MM.yyyy"

        return dateformater.string(from: date)
    }
    
    var posterUrl:String{
        return imgaeBaseIrl + self.thumbUrl
    }
    
    init(_ json:JSON,videoId:String) {
        
        self.videoId = videoId
        self.id = json[ApiKey.id].stringValue
        self.title = json[ApiKey.title].stringValue
        self.release_date = json[ApiKey.release_date].stringValue
        self.thumbUrl = json[ApiKey.poster_path].stringValue
        self.overview = json[ApiKey.overview].stringValue
        
        var allGen = [String]()
        let _ = json[ApiKey.genres].arrayValue.map{
            let name = $0[ApiKey.name].stringValue
            allGen.append(name)
        }
        self.genres = allGen.joined(separator: ",")
    }
}

//MARK:-Model to store Movie Details in Local DB

class MovieDetailsDBModel : Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var thumbUrl      : String = ""
    @objc dynamic var title    : String = ""
    @objc dynamic var release_date    : String = ""
    @objc dynamic var overview    : String = ""
    @objc dynamic var genres    : String = ""
    @objc dynamic var videoId    : String = ""
    
    var dateStr:String{
        
        let dateformater = DateFormatter()
        dateformater.dateFormat = "yyyy-MM-dd"
        guard let date = dateformater.date(from: self.release_date) else {return "NA"}
        dateformater.dateFormat = "dd.MM.yyyy"
        return dateformater.string(from: date)
    }
    
    var posterUrl:String{
        return imgaeBaseIrl + self.thumbUrl
    }
    
    override static func primaryKey() -> String? {
        return ApiKey.id
    }
}

extension MovieDetailsDBModel {
    
    static func saveDataToLocal(_ data:MovieDetailsModel){
        
        let nModel = MovieDetailsDBModel()
        nModel.copyWithContactModel(data)
        do{
            let realm = try Realm()
            try? realm.write {
                realm.add(nModel, update: true)
            }
        }catch{
            
        }
    }
    
    func copyWithContactModel(_ model : MovieDetailsModel) {
        self.id = model.id
        self.thumbUrl = model.thumbUrl
        self.title = model.title
        self.release_date = model.release_date
        self.overview = model.overview
        self.genres = model.genres
        self.videoId = model.videoId
    }
}
