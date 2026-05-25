//
//  EffectManager.swift
//  Game
//
//  Created by ntust on 2026/5/25.
//

import Foundation
import SpriteKit

func spawnHitEffect(at point: CGPoint, in scene: SKScene?) {
    guard let scene = scene else { return }
    
    let emitter = SKEmitterNode()
    emitter.particleTexture = SKTexture(imageNamed: "spark")
    
    // 基本設定
    emitter.particleBirthRate = 100
    emitter.numParticlesToEmit = 30
    emitter.particleLifetime = 0.4
    emitter.particleLifetimeRange = 0.2
    
    // 噴出方向
    emitter.emissionAngle = .pi / 2      // 朝上
    emitter.emissionAngleRange = .pi * 2 // 360度散開
    
    // 速度
    emitter.particleSpeed = 50
    emitter.particleSpeedRange = 300
    
    // 大小
    emitter.particleScale = 0.3
    emitter.particleScaleRange = 0.1
    emitter.particleScaleSpeed = -0.5    // 慢慢縮小消失
    
    // 顏色
    emitter.particleColor = .orange
    emitter.particleColorBlendFactor = 1.0
    emitter.particleColorSequence = SKKeyframeSequence(
        keyframeValues: [UIColor.red, UIColor(red: 0.7, green: 0, blue: 0, alpha: 1)],
        times: [0, 1.0]
    )
    
    // 重力
    emitter.yAcceleration = -500
    
    emitter.position = point
    emitter.zPosition = 10
    scene.addChild(emitter)
    
    emitter.run(.sequence([
        .wait(forDuration: 0.5),
        .removeFromParent()
    ]))
}

func applyDarknessEffect(to scene: SKScene, player: Player) {
    guard let camera = scene.camera else { return }

    // 建立黑色遮罩 texture
    let overlaySize = CGSize(width: scene.size.width * 2,
                             height: scene.size.height * 2)

    let renderer = UIGraphicsImageRenderer(size: overlaySize)
    let image = renderer.image { ctx in
        let cgCtx = ctx.cgContext

        // 先填滿黑色
        cgCtx.setFillColor(UIColor.black.cgColor)
        cgCtx.fill(CGRect(origin: .zero, size: overlaySize))

        // 中間挖圓洞（
        let radius: CGFloat = 80  // 控制光圈大小
        let center = CGPoint(x: overlaySize.width / 2, y: overlaySize.height / 2)
        let holeRect = CGRect(x: center.x - radius, y: center.y - radius,
                              width: radius * 2, height: radius * 2)

        cgCtx.setBlendMode(.clear)
        cgCtx.fillEllipse(in: holeRect)
    }

    let texture = SKTexture(image: image)
    let overlay = SKSpriteNode(texture: texture, size: overlaySize)
    overlay.zPosition = 50
    overlay.name = "darknessOverlay"
    overlay.alpha = 0.95  // 調這個控制黑暗程度

    camera.addChild(overlay)
}

func updateDarknessOverlay(_ scene: SKScene, _ player: Player) {
    guard let camera = scene.camera,
          let overlay = camera.childNode(withName: "darknessOverlay") as? SKSpriteNode
    else { return }

    // 玩家在世界座標的位置，轉換成 camera 的本地座標
    let playerPosInCamera = scene.convert(player.position, to: camera)
    overlay.position = playerPosInCamera
}
