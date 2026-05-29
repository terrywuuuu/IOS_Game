//
//  GameApp.swift
//  Game
//
//  Created by ntust on 2026/4/27.
//

import SwiftUI

@main
struct GameApp: App {
    var body: some Scene {
        WindowGroup {
            //GameView(selectedLevel: 1, selectedPlayer: 1)
            LevelSelectionView()
        }
    }
}
