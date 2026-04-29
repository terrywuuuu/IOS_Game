import SpriteKit

enum GameState {
    case playing
    case paused
    case win
    case lose
}

class GameStateManager {
    var state: GameState = .playing

    func lose() {
        state = .lose
    }

    func win() {
        state = .win
    }

    func pause() {
        state = .paused
    }
}
