//
//  ViewController.swift
//  videoPlayer1
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    var playerView:videoPlayer1?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerView = videoPlayer1.playerView()
        self.view.addSubview(playerView!)
        
        let url = URL(string:"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4")//
        let item = AVPlayerItem(url : url!)
        playerView?.playerItem = item
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerView?.frame = view.bounds
    }

}

