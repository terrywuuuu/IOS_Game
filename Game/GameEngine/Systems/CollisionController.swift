//
//  CollisionManager.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

class CollisionManager {
    weak var player: Player?

    init(player: Player) {
        self.player = player
    }
    
    func handle(_ contact: SKPhysicsContact) {
        let a = contact.bodyA.categoryBitMask
        let b = contact.bodyB.categoryBitMask
        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.ground) {
            var normal = contact.contactNormal

            // contactNormal points from bodyA -> bodyB. If bodyA is player, invert to get normal relative to player
            if contact.bodyA.categoryBitMask == PhysicsCategory.player {
                normal = CGVector(dx: -normal.dx, dy: -normal.dy)
            }

            if normal.dy > 0.5 {
                player?.land()
            } else if let p = player, contact.contactPoint.y < p.position.y - (p.size.height * 0.3) {
                player?.land()
            }
        }

        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.fallingPlat) {
            var normal = contact.contactNormal

            if contact.bodyA.categoryBitMask == PhysicsCategory.player {
                normal = CGVector(dx: -normal.dx, dy: -normal.dy)
            }

            // determine which body is the platform
            let platNode: SKNode? = (contact.bodyA.categoryBitMask == PhysicsCategory.fallingPlat) ? contact.bodyA.node : contact.bodyB.node

            if normal.dy > 0.5 {
                player?.land()
                (platNode as? FallingPlatform)?.triggerFall()
            } else if let p = player, contact.contactPoint.y < p.position.y - (p.size.height * 0.3) {
                player?.land()
                (platNode as? FallingPlatform)?.triggerFall()
            }
        }
        
        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.enemy) {
            player?.takeDamage()
            AudioManager.shared.playHurt()
        }
        
        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.coin) {
            if a==PhysicsCategory.coin {
                contact.bodyA.node?.removeFromParent()
            }
            
            if b==PhysicsCategory.coin {
                contact.bodyB.node?.removeFromParent()
            }
            
            GameManager.shared.addCoin()
            AudioManager.shared.playCoin()
            DataManager.shared.meatCount += 1
        }
        
        if isPair(a, b, PhysicsCategory.attack, PhysicsCategory.enemy) {
            spawnHitEffect(at: contact.contactPoint, in: contact.bodyB.node?.scene)
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            AudioManager.shared.playAttacked()
            DataManager.shared.enemyKilled += 1
        }

        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.checkpoint) {
            if a==PhysicsCategory.checkpoint {
                guard let node = contact.bodyA.node else { return }
                GameManager.shared.activateCheckpoint(point: node.position)
                contact.bodyA.node?.removeFromParent()
            }
            
            if b==PhysicsCategory.checkpoint {
                guard let node = contact.bodyB.node else { return }
                GameManager.shared.activateCheckpoint(point: node.position)
                contact.bodyB.node?.removeFromParent()
            }
            
            AudioManager.shared.playItem()
        }

        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.levelEnd) {
            GameManager.shared.levelComplete()
            AudioManager.shared.platWin()
        }

        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.item) {
            if a==PhysicsCategory.item {
                contact.bodyA.node?.removeFromParent()
            }
            
            if b==PhysicsCategory.item {
                contact.bodyB.node?.removeFromParent()
            }

            let item = getRandomItem()
            print("Got item:", item)
            guard let p = player else { return }
            item.apply(to: p)
            AudioManager.shared.playItem()
        }
        
        if isPair(a, b, PhysicsCategory.player, PhysicsCategory.darkItem) {
            if a==PhysicsCategory.darkItem {
                contact.bodyA.node?.removeFromParent()
            }
            
            if b==PhysicsCategory.darkItem {
                contact.bodyB.node?.removeFromParent()
            }
            
            let item = DarknessItem()
            guard let p = player else { return }
            item.apply(to: p)
            AudioManager.shared.playItem()
        }
    }
    
    func isPair(_ a:UInt32, _ b:UInt32, _ c1:UInt32, _ c2:UInt32) -> Bool {
        return (a==c1 && b==c2) || (a==c2 && b==c1)
    }
}
