//
//  PlayerState.swift
//  Game
//
//  Created by ntust on 2026/5/7.
//

import Foundation
import SpriteKit

enum PlayerState {
    case idle
    case walking
    case jumping
    case falling
    case attacking
}

extension Player {
    func changeState(to newState: PlayerState) {
        if state == newState { return }
        state = newState

        removeAllActions()

        switch state {
        case .idle:
            stopWalkAnimation()

        case .walking:
            playWalkAnimation()

        case .jumping:
            playJumpAnimation()

        case .falling:
            playLandAnimation()

        case .attacking:
            playAttackAnimation()
        }
    }
    
    func canChangeToMoveState() -> Bool {
        switch state {
        case .attacking:
            return false

        default:
            return true
        }
    }
}
