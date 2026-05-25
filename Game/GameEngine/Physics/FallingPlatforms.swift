//
//  FallingPlatforms.swift
//  Game
//
//  Created by ntust on 2026/5/24.
//

import Foundation
import SpriteKit

class FallingPlatform: SKSpriteNode {
    var originalPosition: CGPoint
    var isTriggered: Bool
    
    init(originalPosition: CGPoint, isTriggered: Bool = false, width: CGFloat, height: CGFloat) {
        // initialize subclass stored properties first
        self.originalPosition = originalPosition
        self.isTriggered = isTriggered

        // call a designated initializer of SKSpriteNode
        let size = CGSize(width: width, height: height)
        super.init(texture: nil, color: .gray, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func triggerFall() {
        guard !isTriggered else { return }
        isTriggered = true

        // 震動提示
        let shake = SKAction.sequence([
            SKAction.moveBy(x: 4, y: 0, duration: 0.05),
            SKAction.moveBy(x: -8, y: 0, duration: 0.1),
            SKAction.moveBy(x: 4, y: 0, duration: 0.05)
        ])

        run(SKAction.sequence([
            shake,
            SKAction.wait(forDuration: 0.3),
            SKAction.run { [weak self] in
                self?.physicsBody?.categoryBitMask = 0
            },
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.wait(forDuration: 1.0),
            SKAction.run { [weak self] in
                guard let self else { return }
                self.position = self.originalPosition
                self.physicsBody?.categoryBitMask = PhysicsCategory.fallingPlat
                self.isTriggered = false
            },
            SKAction.fadeIn(withDuration: 0.3)
        ]))
    }
}
