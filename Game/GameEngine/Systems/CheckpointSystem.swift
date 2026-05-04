import SpriteKit

class CheckpointManager {
    var respawnPoint = CGPoint(x: 150,y: 300)
    var count = 0

    func activateCheckpoint(point:CGPoint) {
        respawnPoint = point
        count += 1
        DataManager.shared.checkPoint = count
    }

    func respawn(player: Player) {
        print("Respawning player at checkpoint:", respawnPoint)

        player.position = respawnPoint
        player.physicsBody?.velocity = .zero
        player.canJump = true
    }
}
