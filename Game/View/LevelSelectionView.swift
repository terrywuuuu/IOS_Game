import SwiftUI

struct LevelSelectionView: View {
    // 遊戲資料狀態
    @State private var selectedLevel: Int = 1
    @State private var selectedPlayer: Int = 1 // 1: player1, 2: player2
    @State private var volume: Double = 55
    
    // 介面切換狀態
    @State private var showSettings = false
    @State private var showInstructions = false
    @State private var navigateToGame = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景圖
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                
                // --- 主頁面內容 ---
                VStack {
                    // 右上角設定按鈕
                    HStack {
                        Spacer()
                        Button(action: { showSettings = true }) {
                            SettingsGearIcon()
                        }
                        .padding(.trailing, 40)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // 中間關卡按鈕
                    HStack(spacing: 80) {
                        LevelCircle(num: 1, isSelected: selectedLevel == 1) { selectedLevel = 1 }
                        LevelCircle(num: 2, isSelected: selectedLevel == 2) { selectedLevel = 2 }
                    }
                    
                    Spacer()
                    
                    // 開始按鈕
                    Button(action: { navigateToGame = true }) {
                        StartButtonLabel()
                    }
                    .padding(.bottom, 60)
                }
                
                // 裝飾小怪獸
                VStack {
                    Spacer()
                    HStack {
                        Image("player1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.leading, 30)
                        Spacer()
                        Image("player2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .padding(.trailing, 30)
                    }
                }
                
                // --- 彈窗層 ---
                
                // 1. 設定頁面彈窗 (圖一)
                if showSettings {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    SettingsOverlay(
                        volume: $volume,
                        selectedPlayer: $selectedPlayer,
                        onInstructions: { showInstructions = true },
                        onBack: { showSettings = false }
                    )
                }
                
                // 2. 遊戲說明頁面彈窗 (圖二)
                if showInstructions {
                    Color.black.opacity(0.8).ignoresSafeArea()
                    InstructionsOverlay(onBack: { showInstructions = false })
                }
            }
            // 修正點：對接你原本 GameView 的正確參數
            .navigationDestination(isPresented: $navigateToGame) {
                GameView(selectedLevel: selectedLevel, selectedPlayer: selectedPlayer)
            }
        }
    }
}
