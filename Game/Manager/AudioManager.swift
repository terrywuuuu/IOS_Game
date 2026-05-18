import SpriteKit
import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    private weak var gameScene: SKScene?
    private var walkPlayer: AVAudioPlayer?
    
    func setScene(_ scene: SKScene) {
        self.gameScene = scene
    }

    func playBGM() {
        let music = SKAudioNode(
            fileNamed: "bgm.mp3"
        )
        gameScene?.addChild(music)
    }

    func playJump() {
        let sound = SKAction.playSoundFileNamed(
            "jump.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playAttack() {
        let sound = SKAction.playSoundFileNamed(
            "attack.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playCoin() {
        let sound = SKAction.playSoundFileNamed(
            "coin.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playItem() {
        let sound = SKAction.playSoundFileNamed(
            "item.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playHurt() {
        let sound = SKAction.playSoundFileNamed(
            "hurt.wav",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func platWin() {
        let sound = SKAction.playSoundFileNamed(
            "win.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playLose() {
        let sound = SKAction.playSoundFileNamed(
            "lose.mp3",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
    
    func playWalk() {
        // 不要重播
        if walkPlayer?.isPlaying == true {
            return
        }

        guard let url = Bundle.main.url(
            forResource: "walk",
            withExtension: "mp3"
        ) else {
            return
        }

        do {
            walkPlayer = try AVAudioPlayer(contentsOf: url)

            walkPlayer?.numberOfLoops = -1 // 無限循環
            walkPlayer?.volume = 1.0
            walkPlayer?.play()

        } catch {
            print(error)
        }
    }
    
    func playStop() {
        walkPlayer?.stop()
        walkPlayer?.currentTime = 0
    }
}
