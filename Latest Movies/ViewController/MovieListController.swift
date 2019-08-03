//
//  MovieListController.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 03/08/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

//MARK:-Protocol to update data in Movie List
protocol MovieListControllerProtocol:class{
    func updateData()
}

class MovieListController:NSObject{

    //MARK:-Properties
    public var movies: Results<MovieListDBModel>?  = nil
    var movieList = [MovieListDBModel]()
    var allmovieList = [MovieListDBModel]()
    var isSearch = false
    public var notificationToken: NotificationToken? = nil
    var totalPage = 0
    var currentPage = 0
    weak var delegate:MovieListControllerProtocol?

    //MARK:-Method to get data from local DB
    func getDataFromLocal(){
        
        do{
            
            let realm = try Realm()
            self.movies = realm.objects(MovieListDBModel.self)
            
            let predicate = NSPredicate(format: "id == %@", "page")
            if let record = realm.objects(MovieRecordDBModel.self).filter(predicate).first{
                self.totalPage = record.totalPage
                self.currentPage = record.page
            }
            if let mov = self.movies{
                self.movieList = Array(mov)
                self.allmovieList = Array(mov)
                self.delegate?.updateData()
            }
            if self.allmovieList.isEmpty{
                self.getMovieList()
            }
            self.notificationToken = self.movies?.observe { change in
                if let mov = self.movies{
                    self.movieList = Array(mov)
                    self.allmovieList = Array(mov)
                    self.delegate?.updateData()
                }
            }
        }catch{
            print("Error to fetch data from local")
        }
    }
    
    //MARK:-Method to get data from WebService

    func getMovieList(){
        
        var params = JSONDictionary()
        params[ApiKey.api_key] = AppConstant.Api_Key
        params[ApiKey.page] = self.currentPage + 1
        
        WebServices.getMovieList(parameters: params, success: { (json) in
            let array = MovieListModel.getModelArray(json)
            self.currentPage += 1
            self.totalPage = json[ApiKey.total_pages].intValue
            let _ = MovieRecordDBModel.saveUpdateData(self.currentPage, totalPage: self.totalPage)
            MovieListDBModel.saveDataToLocal(array)
        }) { (error) -> (Void) in
            print(error.localizedDescription)
        }
    }
    
    //MARK:-Method to get search data from list

    func getSrarchData(_ searchStr:String){
        
        // Filter the data array and get only those Movies that match the search text.
        if searchStr.isEmpty{
            self.movieList = self.allmovieList
        }else{
            self.movieList = self.allmovieList.filter({ (movie) -> Bool in
                let title = movie.title
                return title.lowercased().contains(searchStr.lowercased())
            })
        }
        self.delegate?.updateData()
    }

}
