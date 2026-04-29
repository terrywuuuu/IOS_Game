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

        camera.position.x = player.position.x
    }
}