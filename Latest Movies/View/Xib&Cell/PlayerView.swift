//
//  PlayerView.swift
//  Example
//
//  Created by Moayad Al kouz on 8/13/18.
//  Copyright © 2018 Moayad Al kouz. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class PlayerView: UIView {
    
    //MARK:-IBOUTLETS
    @IBOutlet weak var ytPlayerView: YTPlayerView!
    @IBOutlet weak var btnFullScreen: UIButton!
    @IBOutlet weak var controlsView: UIView!
    
    //MARK:-Properties
    private var isFullScreen = true
    
    var videoId: String = ""{
        didSet{
            if !videoId.isEmpty{
                loadVideo()
            }
        }
    }
    
    private func loadVideo(){
        let playerVars:[String: Any] = [
            "controls" : "0",
            "showinfo" : "0",
            "autoplay": "0",
            "rel": "0",
            "modestbranding": "0",
            "iv_load_policy" : "3",
            "fs": "0",
            "playsinline" : "1"
        ]
        ytPlayerView.delegate = self
        ytPlayerView.webView?.tintColor = .black
        ytPlayerView.webView?.backgroundColor = .black
        ytPlayerView.webView?.isOpaque = false
        _ = ytPlayerView.load(withVideoId: videoId, playerVars: playerVars)
        ytPlayerView.isUserInteractionEnabled = false
    }
    
    //MARK:-IBACTIONS
    @IBAction func toogleFullScreen(sender: UIButton){
        
        guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else {
            return
        }
        ytPlayerView.stopVideo()
        rootVC.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playStop(sender: UIButton){
        if ytPlayerView.playerState() == .playing{
            ytPlayerView.pauseVideo()
            sender.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }else{
            ytPlayerView.playVideo()
            sender.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
    }
    
    @objc func startEditingSlider(){
        self.ytPlayerView.pauseVideo()
    }
    
}

//MARK:Implement YTPlayerViewDelegate
extension PlayerView: YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended{
            guard let rootVC = UIApplication.shared.delegate?.window??.rootViewController else {
                return
            }
            ytPlayerView.stopVideo()
            rootVC.dismiss(animated: true, completion: nil)

        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo quality: YTPlaybackQuality) {
        print("Quality :: ", quality)
    }

}
