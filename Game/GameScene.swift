//
//  GameScene.swift
//  Game
//
//  Created by ntust on 2026/4/18.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let player = Player()
    let levelBuilder = LevelBuilder()
    var collisionManager: CollisionManager!
    let gameCamera = SKCameraNode()
    var cameraController: CameraController!
    let timeManager = TimeManager()
    
//    private var label : SKLabelNode?
//    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = CGVector(dx: 0,dy: -15)

        physicsWorld.contactDelegate = self

        AudioManager.shared.setScene(self)
        AudioManager.shared.playBGM()

        collisionManager = CollisionManager(player: player)

        levelBuilder.build(scene: self, player: player)

        gameCamera.position = player.position
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

            GameManager.shared.gameStateManager.state = .lose
        }

        // Register for UI control commands (used by SwiftUI buttons for testing)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleControlCommand(_:)),
                                               name: Notification.Name("GameControl"),
                                               object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("GameControl"), object: nil)
    }

    @objc private func handleControlCommand(_ note: Notification) {
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

        default:
            break
        }
    }
//
//
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green
//            self.addChild(n)
//        }
//    }
//
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue
//            self.addChild(n)
//        }
//    }
//
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red
//            self.addChild(n)
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//
//
    
    func didBegin(_ contact: SKPhysicsContact) {
        collisionManager.handle(contact)
    }
    
    override func update(_ currentTime: TimeInterval) {
        switch GameManager.shared.gameStateManager.state {
        case .playing:
            player.update()
            cameraController.update()
            break
        case .paused:
            return
        case .win:
            // 顯示勝利畫面
            print("Victory")
            return
        case .lose:
            // 顯示失敗畫面
            print("Game Over")
            return
        }
    }
}
