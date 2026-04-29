import SpriteKit

class CheckpointManager {
    var respawnPoint = CGPoint(x: 200,y: 300)

    func activateCheckpoint(point:CGPoint) {
        respawnPoint = point
    }

    func respawn(player: Player) {
        player.position = respawnPoint
        player.physicsBody?.velocity = .zero
    }
}