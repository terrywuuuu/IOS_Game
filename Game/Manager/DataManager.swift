//
//  DataManager.swift
//  Game
//
//  Created by ntust on 2026/5/4.
//

import Foundation
import Combine

@MainActor
final class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var playerHealth: Int = 3
    @Published var playerScore: Int = 0
    @Published var checkPoint: Int = 0
    @Published var timeRemaining: Int = 120
    @Published var activeEffect: String? = nil
    @Published var activeEffectExpiresAt: Date? = nil
    @Published var playerHasAttack: Bool = false
    
    private init() {}
}
