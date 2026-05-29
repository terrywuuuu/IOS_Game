//
//  InstructionsOverlay.swift
//  Game
//
//  Created by 王鈺晴 on 2026/5/29.
//

import SwiftUI

struct InstructionsOverlay: View {
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 35) {
            // 說明圖示網格（精準對應你 Assets 裡面的圖檔檔名）
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 25) {
                InstructionRow(img: "moveLeft", text: "左右移動")
                InstructionRow(icon: "star.fill", text: "生命") // 如果你有愛心圖檔可改成 img: "heart"
                InstructionRow(img: "jump", text: "跳躍")
                InstructionRow(img: "enemy1", text: "敵人")
                InstructionRow(img: "attack", text: "攻擊")
                InstructionRow(img: "weapon", text: "武器")
                InstructionRow(img: "checkpoint", text: "檢查點")
                InstructionRow(img: "item1", text: "隨機道具")
            }
            .padding(.horizontal, 40)
            
            // 返回按鈕
            Button(action: onBack) {
                Text("返回")
                    .font(.headline).bold()
                    .padding(.horizontal, 50)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .foregroundColor(.black)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.4, green: 0.0, blue: 1.0), lineWidth: 4))
                    .cornerRadius(12)
            }
        }
        .padding(40)
        .background(Color.black.opacity(0.95))
        .cornerRadius(25)
        .frame(width: 650)
    }
}

// MARK: - 輔助小元件（統一放在這，防止專案內重複定義）

struct InstructionRow: View {
    var img: String? = nil
    var icon: String? = nil
    var text: String
    
    var body: some View {
        HStack(spacing: 20) {
            if let imgName = img {
                Image(imgName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
            } else if let iconName = icon {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 35, height: 35)
            }
            Text(text)
                .foregroundColor(.white)
                .font(.title3)
            Spacer()
        }
    }
}

struct LevelCircle: View {
    let num: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(num)")
                .font(.system(size: 44, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .frame(width: 110, height: 110)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(isSelected ? Color(red: 0.4, green: 0.0, blue: 1.0) : Color.clear, lineWidth: 5))
        }
    }
}

struct StartButtonLabel: View {
    var body: some View {
        Text("開始！")
            .font(.title2).bold()
            .foregroundColor(.black)
            .padding(.horizontal, 55)
            .padding(.vertical, 14)
            .background(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color(red: 0.4, green: 0.0, blue: 1.0), lineWidth: 5))
            .cornerRadius(16)
    }
}

struct SettingsGearIcon: View {
    var body: some View {
        Image(systemName: "gearshape.fill")
            .font(.title2)
            .foregroundColor(.white)
            .padding(12)
            .background(Color(red: 0.4, green: 0.0, blue: 1.0))
            .cornerRadius(14)
    }
}
