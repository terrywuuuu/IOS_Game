//
//  PauseView.swift
//  Game
//
//  Created by ntust on 2026/5/27.
//

import Foundation
import SwiftUI

struct PauseMenuView: View {
    let onResume: () -> Void
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            // 半透明背景
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("暫停")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Button {
                    onResume()
                } label: {
                    Text("繼續遊戲")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(12)
                }

                Button {
                    DataManager.shared.resetData()
                    onQuit()
                } label: {
                    Text("退出")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.red)
                        .cornerRadius(12)
                }
            }
        }
    }
}
