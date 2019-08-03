//
//  PopularMovieModel.swift
//  Latest Movies
//
//  Created by Ravi on 31/07/19.
//  Copyright © 2019 Ravi. All rights reserved.

import Foundation
import SwiftyJSON
import RealmSwift
import Realm

//MARK:-Model to store Movie List in Temperary
struct MovieListModel {
    
    //MARK:-Properties
    
    var id:String
    var thumbUrl:String
    var title:String
    
    
    var posterUrl:String{
        return imgaeBaseIrl + self.thumbUrl
    }
    
    init(_ json:JSON) {
        self.id = json[ApiKey.id].stringValue
        self.thumbUrl = json[ApiKey.poster_path].stringValue
        self.title = json[ApiKey.title].stringValue
    }
    
    static func getModelArray(_ json:JSON)->[MovieListModel]{
        
        var array = [MovieListModel]()
        let  _ = json[ApiKey.results].arrayValue.map{
            let model = MovieListModel($0)
            array.append(model)
        }
        return array
    }
}

//MARK:-Model to store Movie List in Local DB

class MovieListDBModel : Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var thumbUrl      : String = ""
    @objc dynamic var title    : String = ""
    
    var posterUrl:String{
        return imgaeBaseIrl + self.thumbUrl
    }
    
    override static func primaryKey() -> String? {
        return ApiKey.id
    }
}

extension MovieListDBModel {
  
    static func saveDataToLocal(_ data:[MovieListModel]){
        
        var allData = [MovieListDBModel]()
        let _ = data.map{
            let nModel = MovieListDBModel()
            nModel.copyWithContactModel($0)
            allData.append(nModel)
        }
        do{
            let realm = try Realm()
            try? realm.write {
                realm.add(allData, update: true)
            }
        }catch{
            
        }
    }
    
    func copyWithContactModel(_ model : MovieListModel) {
        self.id = model.id
        self.thumbUrl = model.thumbUrl
        self.title = model.title
    }
}

//MARK:-Model to store Pagination Records in Local DB

class MovieRecordDBModel : Object {
    
    @objc dynamic var id : String = ""
    @objc dynamic var page      : Int = 0
    @objc dynamic var totalPage    : Int = 0

    override static func primaryKey() -> String? {
        return ApiKey.id
    }
    
    static func saveUpdateData(_ page:Int,totalPage:Int)->MovieRecordDBModel{
        let nModel = MovieRecordDBModel()
        do{
            let realm = try Realm()
            try? realm.write {
                nModel.copyWithContactModel(page, totalPage: totalPage)
                realm.add(nModel, update: true)
            }
        }catch{
            
        }
        return nModel
    }
    
    static func getRecord()->MovieRecordDBModel?{
        
        var newRecord:MovieRecordDBModel?
        do{
            
            let realm = try Realm()
            
            let predicate = NSPredicate(format: "id == %@", "page")
            if let record = realm.objects(MovieRecordDBModel.self).filter(predicate).first{
               newRecord = record
            }
        }catch{
            print("Error")
        }
        
        return newRecord
    }
}

extension MovieRecordDBModel {
    
    func copyWithContactModel(_ page:Int,totalPage:Int) {
        self.id = "page"
        self.page = page
        self.totalPage = totalPage
    }
}
