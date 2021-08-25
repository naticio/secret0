//
//  Video.swift
//  Secret0
//
//  Created by Nat-Serrano on 8/25/21.
//
import SwiftUI
import AVKit
import AVFoundation

struct WelcomeVideo: View {
    var body: some View {
        ZStack {
            WelcomeVideoController()
        }
        
    }
}

struct WelcomeVideo_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeVideo()
            .edgesIgnoringSafeArea(.all)
    }
    
}

final class WelcomeVideoController : UIViewControllerRepresentable {
    var playerLooper: AVPlayerLooper?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<WelcomeVideoController>) ->
        AVPlayerViewController {
            let controller = AVPlayerViewController()
            controller.showsPlaybackControls = false
            
            guard let path = Bundle.main.path(forResource: "welcome", ofType:"mp4") else {
                debugPrint("welcome.mp4 not found")
                return controller
            }
                    
            let asset = AVAsset(url: URL(fileURLWithPath: path))
            let playerItem = AVPlayerItem(asset: asset)
            let queuePlayer = AVQueuePlayer()
        
            // OR let queuePlayer = AVQueuePlayer(items: [playerItem]) to pass in items
            playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
            queuePlayer.play()
            
            controller.player = queuePlayer
        //to make this video fullscreen babies
            controller.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspectFill.rawValue)
            

                
            return controller
        }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<WelcomeVideoController>) {
    }
}
