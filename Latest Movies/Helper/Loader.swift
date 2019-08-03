//
//  Loader.swift
//  veme
//
//  Created by Ravi Gangwar on 31/07/19.
//  Copyright © 2019 Ravi Gangwar. All rights reserved.
//

import Foundation
import UIKit

class Loader : UIView {
    
    let spinnerBackView = UIView()
    var spinner: UIActivityIndicatorView!
    var isLoading = false
    var loadingMessage = "Loading..."
    private var cancelAction:(()->())? = nil
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.width, height: UIScreen.height))
        
        let spinnerBackViewWidth : CGFloat = loadingMessage == "" ? 100 : 194
        let spinnerBackViewHeight : CGFloat = loadingMessage == "" ? 100 : 130
            
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5986729452)
        self.isUserInteractionEnabled = true
        
        self.spinnerBackView.frame = CGRect(x: (UIScreen.width - spinnerBackViewWidth)/2, y: (UIScreen.height - spinnerBackViewHeight)/2, width: spinnerBackViewWidth, height: spinnerBackViewHeight)
        self.spinnerBackView.backgroundColor = UIColor.clear
        self.spinnerBackView.layer.cornerRadius = 20.0
        self.spinnerBackView.clipsToBounds = true

        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))//NVActivityIndicatorView(frame: CGRect.zero, type: type, color: loaderColor, padding: 10)
        spinner.style = .whiteLarge
        self.spinner = spinner
        self.spinnerBackView.addSubview(self.spinner)

        self.addSubview(self.spinnerBackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not Loading Properly")
    }
    
    @objc func start(_ onView: UIView, cancelAction:(()->())? = nil)
    {
        if self.isLoading {
            
            if cancelAction != nil {
                if let btn = self.viewWithTag(18723){
                    btn.removeFromSuperview()
                }
            }
            return
        }
        if let message = self.viewWithTag(857364) as? UILabel {
            message.text = loadingMessage
        }
        onView.addSubview(self)
        onView.bringSubviewToFront(self)
        if cancelAction != nil {
            let hieght:CGFloat = 64
            let Btn = UIButton(frame: CGRect(x: (self.frame.size.width-hieght)/2, y: (self.frame.size.height-hieght)/2+40, width: hieght, height: hieght))
            Btn.tag = 18723
            Btn.setTitle("Cancel", for: UIControl.State.normal)
            Btn.addTarget(self, action: #selector(Loader.cancelBtnTapped(btn:)), for: UIControl.Event.touchUpInside)
            Btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.addSubview(Btn)
            self.cancelAction = cancelAction
        }
        else if let btn = self.viewWithTag(18723){
            btn.removeFromSuperview()
        }
        
        self.spinner.startAnimating()
        self.isLoading = true
    }
    
    @objc func cancelBtnTapped(btn:UIButton){
        
        if let cancelAction = self.cancelAction{
            cancelAction()
        }
        self.cancelAction = nil
    }
    func setNewFrame(_ frame: CGRect) {
        
        self.frame = frame
        self.isLoading = false
        
        let spinnerBackViewWidth : CGFloat = loadingMessage == "" ? 100 : 194
        let spinnerBackViewHeight : CGFloat = loadingMessage == "" ? 100 : 130
        self.spinnerBackView.frame = CGRect(x: (frame.width - spinnerBackViewWidth)/2, y: (frame.height - spinnerBackViewHeight)/2, width: spinnerBackViewWidth, height: spinnerBackViewHeight)
        let width = min(min(frame.width, frame.height)-5, 60)
        let loaderRect = CGRect(x: (self.spinnerBackView.frame.width-width)/2, y: (self.spinnerBackView.frame.height-width)/2, width: width, height: width)
        self.spinner.frame = loaderRect
    }
    @objc func stop()
    {
        self.spinner.stopAnimating()
        self.removeFromSuperview()
        self.isLoading = false
    }
}
