//
//  Category.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SpriteKit

struct PhysicsCategory {
    static let none: UInt32   = 0

    static let player: UInt32 = 1 << 0
    static let ground: UInt32 = 1 << 1
    static let enemy: UInt32  = 1 << 2
    static let coin: UInt32   = 1 << 3
    static let attack: UInt32 = 1 << 4
    static let checkpoint: UInt32 = 1 << 5
    static let levelEnd: UInt32 = 1 << 6
    static let item: UInt32 = 1 << 7
    static let fallingPlat: UInt32 = 1 << 8
    static let darkItem: UInt32 = 1 << 9
}
