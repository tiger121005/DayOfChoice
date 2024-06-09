//
//  SecondTutorialViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/09.
//

import UIKit
import AVFoundation

class SecondTutorialViewController: UIViewController {
    
    @IBOutlet var playerView: UIView!
    
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 動画のURLを指定
        let asset = NSDataAsset(name:"tutorialMovie")

        let videoUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("tutorialMovie.mp4")
        try! asset!.data.write(to: videoUrl)

        let item = AVPlayerItem(url: videoUrl)
        player = AVPlayer(playerItem: item)
        
        // AVPlayerの再生終了時の通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        
        // 動画再生
        player.play()
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        playerView.layer.addSublayer(playerLayer)
        
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        // 動画再生を初めから再開
        player.seek(to: CMTime.zero)
        player.play()
    }
    
}
