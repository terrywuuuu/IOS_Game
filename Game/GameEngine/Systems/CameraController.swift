import SpriteKit

class CameraController {
    weak var cameraNode: SKCameraNode?
    weak var player: Player?

    init(camera: SKCameraNode, player: Player) {
        self.cameraNode = camera
        self.player = player
    }

    func update() {
        guard
            let camera = cameraNode,
            let player = player
        else { return }
        
        if player.position.x < 450 { return } // prevent camera from moving before player reaches 450

        camera.position.x = player.position.x
    }
}
