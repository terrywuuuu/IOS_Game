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
    
    // --- 新增：結算頁面所需的數據統計 ---
    @Published var meatCount: Int = 0       // 累計獲得的肉塊數量
    @Published var enemyKilled: Int = 0     // 累計擊殺的敵人數量
    
    private init() {}
    
    /// 當玩家點擊「再來一次」或重新載入關卡時，呼叫此方法重置所有遊戲數據
    func resetData() {
        playerHealth = 3
        playerScore = 0
        checkPoint = 0
        timeRemaining = 120
        activeEffect = nil
        activeEffectExpiresAt = nil
        playerHasAttack = false
        
        // 重置統計數據
        meatCount = 0
        enemyKilled = 0
    }
}
