//
//  MovieDetailsController.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 03/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

//MARK:-Protocol to update data in Movie Details
protocol MovieDetailsControllerProtocol:class{
    func updateData()
}

class MovieDetailsController:NSObject{
    
    //MARK:-Properties

    var videoId:String = ""
    var moviedetails : MovieDetailsDBModel!
    public var movies: Results<MovieDetailsDBModel>?  = nil
    public var notificationToken: NotificationToken? = nil
    weak var delegate:MovieDetailsControllerProtocol?
    
    //MARK:-Method to get Movie Details from WebService

    func getMovieDetails(_ id:String){
        
        WebServices.getMovieDetails(id, success: { (json) in
            let movies = MovieDetailsModel(json,videoId:self.videoId)
            MovieDetailsDBModel.saveDataToLocal(movies)
            self.getVideoDetails(id)
        }) { (error) -> (Void) in
            print(error.localizedDescription)
        }
    }
    
    //MARK:-Method to get Movie Details from id bases from local DB

    func getDataFromLocal(_ id:String){
        
        do{
            
            let realm = try Realm()
            let predicate = NSPredicate(format: "id == %@", id)
            
            self.movies = realm.objects(MovieDetailsDBModel.self).filter(predicate)
            if let mov = self.movies{
                self.moviedetails = mov.filter(predicate).first
                self.delegate?.updateData()
            }
            self.notificationToken = self.movies?.observe { change in
                if let mov = self.movies{
                    self.moviedetails = mov.filter(predicate).first
                    self.delegate?.updateData()
                }
            }
        }catch{
            print("Error to fetch data from local")
        }
    }
    
    //MARK:-Method to get Video data from WebService

    func getVideoDetails(_ id:String){
        
        WebServices.getVideoDetails(id, success: { (json) in
            if let videoData = json[ApiKey.results].arrayValue.first(where: { (movie) -> Bool in
                movie[ApiKey.type] == "Trailer"
            }){
                let videoId = videoData[ApiKey.key].stringValue
                if self.moviedetails == nil{return}
                do{
                    let realm = try Realm()
                    try? realm.write {
                        self.moviedetails.videoId = videoId
                        realm.add(self.moviedetails, update: true)
                    }
                }catch{
                    
                }
            }else if  let videoData = json[ApiKey.results].arrayValue.first(where: { (movie) -> Bool in
                movie[ApiKey.type] == "Teaser"
            }){
                let videoId = videoData[ApiKey.key].stringValue
                if self.moviedetails == nil{return}
                do{
                    let realm = try Realm()
                    try? realm.write {
                        self.moviedetails.videoId = videoId
                        realm.add(self.moviedetails, update: true)
                    }
                }catch{
                    
                }
            }
        }) { (error) -> (Void) in
            print(error.localizedDescription)
        }
    }
}
