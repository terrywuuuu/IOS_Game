import SpriteKit

class AudioManager {
    static let shared = AudioManager()
    
    private weak var gameScene: SKScene?
    
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
            "jump.wav",
            waitForCompletion: false
        )
        gameScene?.run(sound)
    }
}