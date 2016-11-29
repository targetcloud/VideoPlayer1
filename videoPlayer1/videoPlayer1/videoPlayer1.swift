//
//  videoPlayer1.swift
//  videoPlayer1
//
//  Created by targetcloud on 2016/11/29.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit
import AVFoundation

class videoPlayer1: UIView {

    var playerItem : AVPlayerItem? {
        didSet{
            player?.replaceCurrentItem(with: playerItem)
            player?.play()
        }
    }
    var player : AVPlayer?
    var playerLayer : AVPlayerLayer?
    var isShowToolView : Bool?
    var progressTimer : Timer?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var toolView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var playOrPauseBtn: UIButton!
    
    class func playerView()->videoPlayer1{
       return Bundle.main.loadNibNamed("videoPlayer1", owner: nil, options: nil)?.first as! videoPlayer1
    }
    
    override func awakeFromNib() {
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        imageView.layer.addSublayer(playerLayer!)
        toolView.alpha = 0
        isShowToolView = false
        progressSlider.setThumbImage(UIImage(named:"thumbImage"), for: .normal)
        progressSlider.setMaximumTrackImage(UIImage(named:"MaximumTrackImage"), for: .normal)
        progressSlider.setMinimumTrackImage(UIImage(named:"MinimumTrackImage"), for: .normal)
        removeProgressTimer()
        addProgressTimer()
        playOrPauseBtn.isSelected = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
    
    func removeProgressTimer(){
        progressTimer?.invalidate()
        progressTimer = nil
    }
    
    func addProgressTimer(){
        progressTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(videoPlayer1.updateProgressInfo), userInfo: nil, repeats: true)
        RunLoop.main.add(progressTimer!, forMode: RunLoopMode.commonModes)
    }
    
    func updateProgressInfo(){
        timeLabel.text = stringWithCurrentTime(CMTimeGetSeconds((player?.currentTime())!),CMTimeGetSeconds((player?.currentItem?.duration)!))
        progressSlider.value = Float(CMTimeGetSeconds((player?.currentTime())!) / CMTimeGetSeconds((player?.currentItem?.duration)!))
    }
    
    func stringWithCurrentTime(_ currentTime:TimeInterval,_ duration:TimeInterval)->String{
        let dMin = Int(duration) / 60
        let dSec = Int(duration) % 60
        let durationString = String(format:"%02ld:%02ld",dMin,dSec)
        let cMin = Int(currentTime) / 60
        let cSec = Int(currentTime) % 60
        let currentString = String(format:"%02ld:%02ld",cMin,cSec)
        return currentString + "/" + durationString
    }
    
    @IBAction func playOrPause(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected{
            player?.play()
            addProgressTimer()
        }else{
            player?.pause()
            removeProgressTimer()
        }
    }
    
    @IBAction func switchOrientation(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
    
    @IBAction func startSlider(_ sender: UISlider) {
        removeProgressTimer()
    }
    
    @IBAction func slider(_ sender: UISlider) {
        addProgressTimer()
        let currentTime = TimeInterval(Float(CMTimeGetSeconds((player?.currentItem?.duration)!)) * progressSlider.value);
        player?.seek(to: CMTimeMakeWithSeconds(currentTime, Int32(NSEC_PER_SEC)), toleranceBefore:kCMTimeZero, toleranceAfter:kCMTimeZero)
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        let currentTime  = TimeInterval(Float(CMTimeGetSeconds((player?.currentItem?.duration)!)) * progressSlider.value);
        let duration : TimeInterval = CMTimeGetSeconds((player?.currentItem?.duration)!);
        timeLabel.text = stringWithCurrentTime(currentTime ,duration)
    }
    
    @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            if self.isShowToolView!{
                self.toolView.alpha = 0
                self.isShowToolView = false
            }else{
                self.toolView.alpha = 1
                self.isShowToolView = true
            }
        })
    }

}
