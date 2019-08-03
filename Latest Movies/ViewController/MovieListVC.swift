//
//  MovieListVC.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit

class MovieListVC: UIViewController {
    
    //MARK:-IBOUTLES
    @IBOutlet weak var searchBottonConstant: NSLayoutConstraint!
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var movieListTV: UITableView!

    //MARK:-Properties
    var isSearch = false
    let controller = MovieListController()
    
    //MARK:View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Movie Catalog"
        self.addKeyboard()

    }
  
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboard()
    }

    //MARK:-Private Method
    private func initialSetup(){
        self.movieListTV.registerCell(nibName: PaginationCell.nibName)
        self.searchView.delegate = self
        self.controller.delegate = self
        self.controller.getDataFromLocal()
    }
    
    //MARK:-Add keyborad Observer
    private func addKeyboard(){
        
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil,
                                               queue: OperationQueue.main,
                                               using: {[weak self] (notification) in
                                                guard let info = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                                                
                                                guard let strongSelf = self else {return}
                                                
                                                let keyBoardHeight = info.cgRectValue.height
                                                
                                                var safeAreaBottomInset : CGFloat = 0
                                                if #available(iOS 11.0, *) {
                                                    safeAreaBottomInset = strongSelf.view.safeAreaInsets.bottom
                                                } else {
                                                    // Fallback on earlier versions
                                                }
                                                //
                                                UIView.animate(withDuration: 0.1,  delay: 0,
                                                               options: .curveEaseInOut,
                                                               animations: {
                                                                
                                                                if (info.cgRectValue.origin.y) >= UIScreen.height {
                                                                    strongSelf.searchBottonConstant.constant = 5.0
                                                                } else {
                                                                    strongSelf.searchBottonConstant.constant = (keyBoardHeight - safeAreaBottomInset)
                                                                }
                                                                strongSelf.view.layoutIfNeeded()
                                                }, completion: nil)
                                                
        })
    }
    
    //MARK:-Remove keyborad Observer

    private func removeKeyboard(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
}

//MARK:Implement MovieListControllerProtocol
extension MovieListVC:MovieListControllerProtocol{
    
    func updateData() {
        self.movieListTV.reloadData()
    }
}

//MARK:Implement UITableView DataSource and Delegate

extension MovieListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch ? controller.movieList.count : controller.movieList.isEmpty ? 0 : (controller.totalPage > 1 && controller.totalPage > controller.currentPage ) ? controller.movieList.count + 1 : controller.movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == controller.movieList.count {
            return self.dequeuePaginationCell(tableView, indexPath: indexPath)
        }
        return self.dequeueMovieCell(tableView, indexPath: indexPath)

    }
    
    func dequeuePaginationCell(_ tableView:UITableView,indexPath:IndexPath)->UITableViewCell{

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PaginationCell") as? PaginationCell else {
            return UITableViewCell()
        }
        cell.activityIndicator.startAnimating()
        controller.getMovieList()
        return cell
    }
    
    func dequeueMovieCell(_ tableView:UITableView,indexPath:IndexPath)->UITableViewCell{
        
        guard let listCell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as? MovieListCell else {
            fatalError()
        }
        listCell.populateDataWithModel(controller.movieList[indexPath.row])
        return listCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) ->
        CGFloat {
        
        if indexPath.row == controller.movieList.count{
            return 50
        }else{
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsScene = MovieDetailsVC.instantiate(fromAppStoryboard: .Main)
        detailsScene.id = controller.movieList[indexPath.row].id
        self.navigationController?.pushViewController(detailsScene, animated: true)
    }
}

//MARK:Implement UISearchBar Delegate
extension MovieListVC:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIScreen.resignKeyBoard()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.isSearch = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        controller.getSrarchData(searchBar.text ?? "")
    }
}
