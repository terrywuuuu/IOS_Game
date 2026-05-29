//
//  GameResultView.swift
//  Game
//
//  Created by 王鈺晴 on 2026/5/29.
//

import SwiftUI

struct GameResultView: View {
    @ObservedObject var data = DataManager.shared
    
    let isSuccess: Bool // true: 恭喜！ , false: 太弱了...
    var onQuit: () -> Void      // 點擊退出
    var onRestart: () -> Void   // 點擊再來一次 (失敗時才會顯示)
    
    var body: some View {
        ZStack {
            // 全黑背景
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // 1. 頂部主標題
                Text(isSuccess ? "恭喜！" : "太弱了...")
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                // 2. 中央數據結算欄 (肉塊與怪獸數量)
                HStack(spacing: 80) {
                    // 肉塊計數 (對應 Asset: meat)
                    HStack(spacing: 20) {
                        Image("meat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text("x \(data.meatCount)") // 💡 如果變數名不同可自行修正
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                    
                    // 敵人計數 (對應設計圖中的小怪獸，此處假設為 enemy1)
                    HStack(spacing: 20) {
                        Image("enemy1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text("x \(data.enemyKilled)") // 💡 如果變數名不同可自行修正
                            .font(.system(size: 40, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 10)
                
                // 3. 底部動作按鈕
                HStack(spacing: 40) {
                    if isSuccess {
                        // 成功畫面：只有一個「退出」按鈕
                        ActionButton(text: "退出", action: onQuit)
                    } else {
                        // 失敗畫面：有「退出」與「再來一次」
                        ActionButton(text: "退出", action: onQuit)
                        ActionButton(text: "再來一次", action: onRestart)
                    }
                }
                .padding(.bottom, 20)
            }
            
            // 4. 左右下角裝飾小怪獸
            VStack {
                Spacer()
                HStack {
                    Image("player1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .padding(.leading, 40)
                    Spacer()
                    Image("player2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .padding(.trailing, 40)
                }
                .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - 專用按鈕元件
struct ActionButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.black)
                .frame(width: 160, height: 55)
                .background(Color(red: 0.85, green: 0.85, blue: 0.85)) // 淺灰色內層
                .cornerRadius(14)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(red: 0.4, green: 0.0, blue: 1.0), lineWidth: 5) // 亮紫色粗邊框
                )
        }
    }
}

// MARK: - 預覽
#Preview("成功狀態", traits: .landscapeRight) {
    GameResultView(isSuccess: true, onQuit: {}, onRestart: {})
}

#Preview("失敗狀態", traits: .landscapeRight) {
    GameResultView(isSuccess: false, onQuit: {}, onRestart: {})
}
