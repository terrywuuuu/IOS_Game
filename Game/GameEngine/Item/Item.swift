protocol Item {

 func apply(to player: Player)
}

let itemPool: [Item] = [
    InvincibleItem(),
    HealthItem(),
    ReverseControlItem()
]

class InvincibleItem: Item {
    func apply(to player: Player) {
        player.setInvincible(true)
    }
}

class HealthItem: Item {
    func apply(to player: Player) {
        player.health += 1
    }
}

class ReverseControlItem: Item {
    func apply(to player: Player) {
        player.reverseControls = true
    }
}

func getRandomItem() -> Item {
    return itemPool.randomElement()!
}