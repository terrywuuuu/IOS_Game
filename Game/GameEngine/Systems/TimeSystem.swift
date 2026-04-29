import Foundation

class TimeManager {
    var timeRemaining = 120

    var gameOverCallback: (() -> Void)?

    func tick() {
        timeRemaining -= 1
        print(timeRemaining)

        if timeRemaining <= 0 {
            timeRemaining = 0
            gameOverCallback?()
        }
    }
}