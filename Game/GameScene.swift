//
//  GameScene.swift
//  Game
//
//  Created by ntust on 2026/4/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let selectedLevel: Int
    let selectedPlayer: Int
    let levelBuilder = LevelBuilder()
    var collisionManager: CollisionManager!
    let gameCamera = SKCameraNode()
    var cameraController: CameraController!
    let timeManager = TimeManager()
    var player: Player!
    
    init(selectedLevel: Int, selectedPlayer: Int) {
        self.selectedLevel = selectedLevel
        self.selectedPlayer = selectedPlayer
        super.init(size: CGSize(width: 1024, height: 768))
        self.player = Player(player: selectedPlayer)
        DataManager.shared.resetData()
        self.resumeGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.resumeGame()
        
        physicsWorld.gravity = CGVector(dx: 0,dy: -15)

        physicsWorld.contactDelegate = self

        AudioManager.shared.setScene(self)
        AudioManager.shared.playGameBGM()

        collisionManager = CollisionManager(player: player)

        levelBuilder.build(scene: self, player: player, level: selectedLevel)

        gameCamera.position = player.position
        if gameCamera.parent != nil {
            gameCamera.removeFromParent()
        }
        addChild(gameCamera)
        self.camera = gameCamera
        cameraController = CameraController(camera: gameCamera, player: player)
        
        run(
            .repeatForever(
                .sequence([
                    .wait(forDuration: 1),
                    .run {
                        self.timeManager.tick()
                    }
                ])
        ))

        timeManager.gameOverCallback = { [weak self] in
            guard self != nil else { return }
            print("Times out")

            GameManager.shared.playerLose()
            AudioManager.shared.playLose()
        }

        print("🟢 GameScene didMove - 新場景已啟動, scene id: \(ObjectIdentifier(self))")
        // 先清除，避免重複註冊
        NotificationCenter.default.removeObserver(self, name: Notification.Name("GameControl"), object: nil)
        // Register for UI control commands (used by SwiftUI buttons for testing)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleControlCommand(_:)),
                                               name: Notification.Name("GameControl"),
                                               object: nil)
    }

    func pauseGame() {
        GameManager.shared.gameStateManager.pause()
        self.isPaused = true
        self.view?.isPaused = true
    }

    func resumeGame() {
        GameManager.shared.gameStateManager.state = .playing
        self.isPaused = false
        self.view?.isPaused = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        print("💀 GameScene deinit - scene id: \(ObjectIdentifier(self))")
    }
    
    override func willMove(from view: SKView) {
        print("🔴 GameScene willMove - 舊場景移除, scene id: \(ObjectIdentifier(self))")
        NotificationCenter.default.removeObserver(self)
    }

    @objc private func handleControlCommand(_ note: Notification) {
        print("📩 收到通知, scene id: \(ObjectIdentifier(self)), command: \(note.userInfo ?? [:])")
        guard let info = note.userInfo as? [String: String],
              let command = info["command"],
              let type = info["type"] else { return }

        switch command {
        case "left":
            if type == "down" {
                player.moveLeft()
            } else if type == "up" {
                player.stop()
            }

        case "right":
            if type == "down" {
                player.moveRight()
            } else if type == "up" {
                player.stop()
            }

        case "jump":
            if type == "tap" { player.jump() }

        case "attack":
            if type == "tap" { player.attack(scene: self) }
            
        case "pause":
            self.pauseGame()
            
        case "resume":
            self.resumeGame()

        default:
            break
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionManager.handle(contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch GameManager.shared.gameStateManager.state {
        case .playing:
            player.update()
            cameraController.update()
            
            if selectedLevel == 2 {
                updateDarknessOverlay(self, player)
            }
            break
        case .paused:
            return
        case .win:
            // 顯示勝利畫面
            print("Victory")
            AudioManager.shared.stopGameBGM()
            
            // 等音效播完 2 秒後，正式暫停遊戲並發通知給 SwiftUI 跳出「恭喜！」結算頁
            run(.sequence([
                .wait(forDuration: 2.0),
                .run { [weak self] in
                    self?.pauseGame()
                    NotificationCenter.default.post(name: Notification.Name("GameSuccess"), object: nil)
                }
            ]))
            return
        case .lose:
            // 顯示失敗畫面
            print("Game Over")
            AudioManager.shared.stopGameBGM()
            
            // 等音效播完再暫停
            run(.sequence([
                    .wait(forDuration: 1.0),
                    .run { [weak self] in
                        self?.pauseGame()
                        NotificationCenter.default.post(name: Notification.Name("GameFailure"), object: nil)
                    }
                ]))
            return
        }
    }
}
