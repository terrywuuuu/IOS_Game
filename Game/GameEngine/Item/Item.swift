import Foundation

protocol Item {
 func apply(to player: Player)
}

let itemPool: [Item] = [
//    InvincibleItem(),
//    HealthItem(),
//    ReverseControlItem(),
    AttackItem(),
//    TimeItem(addSeconds: 10)
]

class InvincibleItem: Item {
    func apply(to player: Player) {
        // Make player invincible for 8 seconds
        player.applyInvincibility(duration: 8.0)
    }
}

class HealthItem: Item {
    func apply(to player: Player) {
        if player.health == 3 { return }
        player.health += 1
        DataManager.shared.playerHealth = player.health
        // show a short-lived UI message for picking up health
        let duration: TimeInterval = 3.0
        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "生命+1"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            DataManager.shared.activeEffect = nil
        }
    }
}

class ReverseControlItem: Item {
    func apply(to player: Player) {
        // Reverse controls for 8 seconds
        player.applyReverseControls(duration: 8.0)
    }
}

class AttackItem: Item {
    func apply(to player: Player) {
        player.hasAttack = true
        // Update shared state so UI can reflect the change
        DispatchQueue.main.async {
            DataManager.shared.playerHasAttack = true
        }
        
        // show a short-lived UI message for picking up health
        let duration: TimeInterval = 3.0
        DispatchQueue.main.async {
            DataManager.shared.activeEffect = "取得武器"
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            DataManager.shared.activeEffect = nil
        }
    }
}

class TimeItem: Item {
    let addSeconds: Int
    let displayDuration: TimeInterval

    init(addSeconds: Int = 10, displayDuration: TimeInterval = 3.0) {
        self.addSeconds = addSeconds
        self.displayDuration = displayDuration
    }

    func apply(to player: Player) {
        // Ensure UI updates happen on main actor
        DispatchQueue.main.async {
            // Add time to the shared DataManager timer
            DataManager.shared.timeRemaining += self.addSeconds
            DataManager.shared.activeEffect = "可以活更久了"

            let expiry = Date().addingTimeInterval(self.displayDuration)
            DataManager.shared.activeEffectExpiresAt = expiry

            DispatchQueue.main.asyncAfter(deadline: .now() + self.displayDuration) {
                // Only clear if the expiry hasn't been extended by another item
                if let currentExpiry = DataManager.shared.activeEffectExpiresAt,
                   currentExpiry <= Date() {
                    DataManager.shared.activeEffect = nil
                    DataManager.shared.activeEffectExpiresAt = nil
                }
            }
        }
    }
}

func getRandomItem() -> Item {
    return itemPool.randomElement()!
}
