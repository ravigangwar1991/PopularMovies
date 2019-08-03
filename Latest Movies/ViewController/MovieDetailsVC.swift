//
//  MovieDetailsVC.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.

import UIKit

class MovieDetailsVC: UIViewController {
    
    //MARK:-IBOUTLETS
    @IBOutlet weak var movieDetailsTV: UITableView!
    
    //MARK:Properties
    var isPortrate = true
    var id:String!
    
    let controller = MovieDetailsController()
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialSetup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Movie Details"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.isPortrate = !(size.width > self.view.frame.size.width)
        self.movieDetailsTV.reloadData()
    }
    
    //MARK:Private Methods
    private func initialSetup(){
        self.isPortrate = UIDevice.current.orientation.isPortrait
        controller.delegate = self
        controller.getMovieDetails(self.id)
        controller.getDataFromLocal(self.id)
    }
}

//MARK:Implement MovieDetailsControllerProtocol
extension MovieDetailsVC:MovieDetailsControllerProtocol{
    
    func updateData() {
        self.movieDetailsTV.reloadData()
    }
}

//MARK:Implement UITableView DataSource and Delegate

extension MovieDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return controller.moviedetails == nil ? 0 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            
            if self.isPortrate{
               return self.dequeuePortraitCell(tableView, indexPath: indexPath)
            }else{
                return self.dequeueLandscapeCell(tableView, indexPath: indexPath)
            }
            
        case 1...3:
            return self.dequeueInfoCell(tableView, indexPath: indexPath)
            
        default:
            fatalError()
        }
    }
    
    func dequeuePortraitCell(_ tableView:UITableView,indexPath:IndexPath)->UITableViewCell{
        
        guard let thumbCell = tableView.dequeueReusableCell(withIdentifier: "MovieThumCell", for: indexPath) as? MovieThumCell else {fatalError()}
        
        thumbCell.populateDataWithModel(controller.moviedetails)
        thumbCell.watchTrailerBtn.addTarget(self, action: #selector(self.watchTrailer(_:)), for: .touchUpInside)
        return thumbCell
        
    }
    
    func dequeueLandscapeCell(_ tableView:UITableView,indexPath:IndexPath)->UITableViewCell{

        guard let thumbCell = tableView.dequeueReusableCell(withIdentifier: "MovieThumb2Cell", for: indexPath) as? MovieThumb2Cell else {fatalError()}
        
        thumbCell.populateDataWithModel(controller.moviedetails)
        thumbCell.watchTrailerBtn.addTarget(self, action: #selector(self.watchTrailer(_:)), for: .touchUpInside)
        return thumbCell
        
    }
    
    func dequeueInfoCell(_ tableView:UITableView,indexPath:IndexPath)->UITableViewCell{
        
        guard let infoCell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell", for: indexPath) as? MovieInfoCell else {fatalError()}
        
        switch indexPath.row {
        case 1:
            infoCell.populateCell("Genres", controller.moviedetails.genres)
        case 2:
            infoCell.populateCell("Date", controller.moviedetails.dateStr)

        case 3:
            infoCell.populateCell("OverView", controller.moviedetails.overview)
            
        default:
            fatalError()
        }
        return infoCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            if self.isPortrate{
                return UITableView.automaticDimension
            }else{
                return 300
            }
        }else{
            return UITableView.automaticDimension
        }
    }
    
    //MARK:-Action to watch Trailer
    @objc func watchTrailer(_ sender:UIButton){
        
        let playerScene = MoviePlayerVC.instantiate(fromAppStoryboard: .Main)
        playerScene.videoId = controller.moviedetails.videoId
        self.navigationController?.present(playerScene, animated: true, completion: nil)
    }
}
