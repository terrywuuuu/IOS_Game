//
//  GameView.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SwiftUI
import SpriteKit

struct GameView: View {
    @StateObject private var data = DataManager.shared

    private let skScene: GameScene
    let selectedLevel: Int
    let selectedPlayer: Int

    init(selectedLevel: Int, selectedPlayer: Int) {
        self.selectedLevel = selectedLevel
        self.selectedPlayer = selectedPlayer
        let scene = GameScene(selectedLevel: selectedLevel, selectedPlayer: selectedPlayer)
        scene.scaleMode = .resizeFill
        self.skScene = scene
    }
    
    var body: some View {
        ZStack {
            // 遊戲場景
            SpriteView(scene: skScene)
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
                            skScene.pauseGame()
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
                            // Change image and size depending on whether player has attack
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
        }
    }
}

#Preview(traits: .landscapeRight) {
    GameView(selectedLevel: 2, selectedPlayer: 1)
}
