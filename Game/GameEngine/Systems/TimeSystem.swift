import Foundation

class TimeManager {
    var gameOverCallback: (() -> Void)?

    func tick() {
        // Ensure we update the shared DataManager on the main thread so
        // SwiftUI will see the change immediately.
        DispatchQueue.main.async {
            DataManager.shared.timeRemaining -= 1
            let tr = DataManager.shared.timeRemaining
            print(tr)

            if tr <= 0 {
                DataManager.shared.timeRemaining = 0
                self.gameOverCallback?()
            }
        }
    }
}
