//
//  GameView.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @Environment(\.dismiss) var dismiss // 用於點選「退出」時，關閉當前頁面返回大廳選單
    @StateObject private var data = DataManager.shared
    @State private var isPaused = false

    // --- 🛠️ 新增：控制結算頁面彈出的狀態 ---
    @State private var showResult = false
    @State private var isSuccess = false

    // --- 🛠️ 新增：控制 SpriteKit 場景刷新的識別碼（再來一次功能關鍵） ---
    @State private var sceneID = UUID()
    
    let selectedLevel: Int
    let selectedPlayer: Int

    // --- 🛠️ 修改：將 skScene 改為計算屬性，這樣場景重置時才能實例化新的 GameScene ---
    private var skScene: GameScene {
        let scene = GameScene(selectedLevel: selectedLevel, selectedPlayer: selectedPlayer)
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            // 遊戲場景（加上 .id(sceneID) 綁定，當識別碼改變時，SpriteView 就會徹底重開機）
            SpriteView(scene: skScene)
                .id(sceneID)
                .ignoresSafeArea()

            // 控制按鈕及遊戲資訊
            VStack {
                HStack {
                    // 左上：生命 + checkpoint
                    HStack(spacing: 12) {
                        // 生命
                        HStack(spacing: 4) {
                            ForEach(0..<data.playerHealth, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        // checkpoint
                        HStack(spacing: 4) {
                            Image(systemName: "flag.fill")
                            Text("\(data.checkPoint)")
                        }
                        .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // 右上：時間 + 設定
                    HStack(spacing: 12) {
                        // 時間
                        Text("⏱ \(data.timeRemaining)")
                            .foregroundColor(.white)
                            .font(.headline)
                        // 設定
                        Button {
                            print("open settings")
                            // 💡 通知 GameScene 暫停遊戲
                            NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"pause"])
                            isPaused = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.title2)
                        }
                    }
                }
                .padding()
                
                // 中央上方：顯示當前道具效果
                if let effect = data.activeEffect {
                    Text("\(effect)")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(8)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }
                
                Spacer()
                
                HStack(spacing: 24) {
                    HStack(spacing: 8) {
                        // Left button
                        Button(action: {
                            NotificationCenter.default.post(
                                name: Notification.Name("GameControl"),
                                object: nil,
                                userInfo: ["command":"left","type":"tap"]
                            )
                        }) {
                            Image("moveLeft")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                            if pressing {
                                NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"left","type":"down"])
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"left","type":"up"])
                            }
                        }, perform: {})

                        // Right button
                        Button(action: {
                            NotificationCenter.default.post(
                                name: Notification.Name("GameControl"),
                                object: nil,
                                userInfo: ["command":"right","type":"tap"]
                            )
                        }) {
                            Image("moveRight")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                        .onLongPressGesture(minimumDuration: 0.01, pressing: { pressing in
                            if pressing {
                                NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"right","type":"down"])
                            } else {
                                NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"right","type":"up"])
                            }
                        }, perform: {})
                        
                        Button(action: {
                            NotificationCenter.default.post(
                                name: Notification.Name("GameControl"),
                                object: nil,
                                userInfo: ["command":"jump","type":"tap"]
                            )
                        }) {
                            Image("jump")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        Button(action: {
                            NotificationCenter.default.post(
                                name: Notification.Name("GameControl"),
                                object: nil,
                                userInfo: ["command":"attack","type":"tap"]
                            )
                        }) {
                            let imgName = data.playerHasAttack ? "attack" : "attack_lock"
                            let size: CGFloat = data.playerHasAttack ? 40 : 50
                            Image(imgName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: size, height: size)
                        }
                    }
                }
                .padding()
            }
            
            // 暫停選單
            if isPaused {
                PauseMenuView(
                    onResume: {
                        isPaused = false
                        // 💡 通知 GameScene 恢復遊戲
                        NotificationCenter.default.post(name: Notification.Name("GameControl"), object: nil, userInfo: ["command":"resume"])
                    },
                    onQuit: {
                        isPaused = false
                        AudioManager.shared.stopGameBGM()
                        dismiss() // 回到大廳
                    }
                )
            }
            
            // --- 🛠️ 新增：全螢幕結算頁面渲染層 ---
            if showResult {
                GameResultView(
                    isSuccess: isSuccess,
                    onQuit: {
                        showResult = false
                        AudioManager.shared.stopGameBGM()
                        dismiss() // 退出回大廳選單
                    },
                    onRestart: {
                        showResult = false
                        data.resetData()     // 1. 洗乾淨 DataManager 數據
                        sceneID = UUID()     // 2. 更改 UUID，強制讓全新 GameScene 重頭載入
                    }
                )
                .transition(.opacity)
                .zIndex(10) // 確保蓋在最上層
            }
        }
        // --- 🛠️ 新增：通知中心接球監聽器 ---
        
        // 1. 監聽從 GameScene 發過來的勝利通知
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("GameSuccess"))) { _ in
            triggerGameOver(success: true)
        }
        
        // 2. 監聽從 GameScene 發過來的失敗通知
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("GameFailure"))) { _ in
            triggerGameOver(success: false)
        }
    }
    
    // 🛠️ 新增：觸發顯現結算層的內部輔助方法
    private func triggerGameOver(success: Bool) {
        isSuccess = success
        withAnimation(.easeInOut) {
            showResult = true
        }
    }
}

#Preview(traits: .landscapeRight) {
    GameView(selectedLevel: 2, selectedPlayer: 2)
}
