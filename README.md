# IOS Game

一款使用 SwiftUI 與 SpriteKit 製作的 2D 動作平台遊戲。玩家可以選擇角色與關卡，在有限時間內穿越平台、避開陷阱、擊敗敵人、收集物品，並抵達終點完成關卡。

## 功能

- 兩個可選擇的遊戲關卡，每個關卡都有獨立的背景與地圖資料
- 兩名可選擇的玩家角色，具有行走、跳躍與攻擊動畫
- 左右移動、跳躍與攻擊等觸控操作
- 敵人、尖刺、移動平台與會掉落的平台
- 金幣、肉塊、武器與隨機道具
- 檢查點與死亡後重生機制
- 生命值、分數、擊殺數、道具效果與倒數計時顯示
- 暫停、重新開始、退出與勝負結算畫面
- 遊戲背景音樂與效果音效
- 第二關的黑暗效果

## 操作方式

| 控制 | 動作 |
| --- | --- |
| 左移按鈕 | 向左移動 |
| 右移按鈕 | 向右移動 |
| 跳躍按鈕 | 跳躍 |
| 攻擊按鈕 | 使用武器攻擊；取得武器後解鎖 |
| 設定按鈕 | 開啟暫停選單 |

每個關卡開始時玩家有 3 點生命與 120 秒時間。碰到危險或時間耗盡會輸掉關卡；抵達終點則完成關卡。

## 開始遊戲

### 環境需求

- macOS
- Xcode
- iOS 26.2 或更新版本的執行環境
- Swift 5

### 建置與執行

1. 使用 Xcode 開啟 `Game.xcodeproj`。
2. 選擇 `Game` scheme。
3. 選擇 iPhone、iPad 模擬器或已連接的實體裝置。
4. 按下 **Run** 執行專案。

專案的 Deployment Target 目前設定為 iOS 26.2，並支援 iPhone 與 iPad。若要在較舊的 iOS 版本執行，需先在 Xcode 的 Build Settings 調整 Deployment Target，並確認使用的 API 與資源相容。

## 遊戲流程

1. 從主畫面選擇關卡與玩家角色。
2. 點選「開始！」進入遊戲。
3. 操作角色通過平台與障礙物，收集金幣和道具。
4. 啟用檢查點後，角色死亡會從最近的檢查點重生。
5. 抵達終點顯示勝利結果；生命歸零或倒數結束則顯示失敗結果。

## 專案結構

```text
Game/
├── GameApp.swift              # SwiftUI 應用程式入口
├── GameView.swift             # SpriteKit 場景與遊戲 HUD
├── GameScene.swift            # 遊戲場景、輸入事件與遊戲循環
├── Assets.xcassets/           # 角色、敵人、物件與介面圖片
├── Effect/                    # SpriteKit 粒子效果與相關資源
├── GameEngine/
│   ├── Enemy/                 # 敵人行為
│   ├── Item/                  # 道具
│   ├── Physics/               # 物理分類與平台
│   ├── Player/                # 玩家狀態、動畫與控制
│   ├── Scene/                 # 關卡載入與建立
│   └── Systems/               # 碰撞、相機、時間與 checkpoint
├── LevelData/                 # level1.json、level2.json
├── Manager/                   # 音效、資料、特效與遊戲狀態管理
├── Model/                     # 關卡資料模型
└── View/                      # 關卡選擇、設定、說明與結算畫面
```

## 關卡資料

關卡配置位於 `Game/LevelData/`，由 `LevelLoader` 讀取 JSON，再交由 `LevelBuilder` 建立 SpriteKit 節點。每個關卡可配置以下內容：

- `levelWidth`：關卡寬度
- `background`：背景圖片資源名稱
- `playerSpawn`：玩家出生位置
- `grounds`、`platforms`：固定地面與平台
- `movingPlatforms`、`fallingPlatforms`：特殊平台
- `enemies`：敵人種類與位置
- `spikes`：尖刺位置
- `coins`：金幣位置
- `items`：道具種類與位置
- `checkpoints`：檢查點位置
- `goal`：終點位置

新增或調整關卡時，請同時確認 JSON 欄位符合 `Game/Model/LevelModel.swift` 中的資料模型，並且圖片名稱已存在於 asset catalog。

## 技術架構

- **SwiftUI**：主畫面、關卡選擇、設定、暫停與結算介面
- **SpriteKit**：遊戲場景、物理碰撞、動畫與攝影機
- **GameplayKit**：遊戲場景使用的 Apple 遊戲框架支援
- **JSON + Codable**：關卡資料定義與載入
- **NotificationCenter**：SwiftUI 控制元件與 SpriteKit 場景之間的操作事件傳遞
- **ObservableObject**：透過 `DataManager` 將生命、時間、分數與道具狀態同步到 HUD

## 目前限制

- 專案目前沒有獨立的 XCTest 測試 target。
- 遊戲需要在支援 iOS 26.2 的 Xcode 與執行環境中建置。