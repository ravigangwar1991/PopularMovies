//
//  MoviePlayerVC.swift
//  Latest Movies
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class MoviePlayerVC: UIViewController {
    
    //MARK:-Properties
    private var playerView: PlayerView!
    var videoId:String!
    
    //MARK:-View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addPlayerView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscape
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK:-Private Methods
    private func initialSetup(){
        
        playerView = UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? PlayerView
        playerView.videoId = self.videoId
    }
    
    private func addPlayerView(){
        self.view = playerView
    }
}

//MARK: Implement YTPlayerViewDelegate

extension MoviePlayerVC: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }

}

