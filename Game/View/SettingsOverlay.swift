import SwiftUI

struct SettingsOverlay: View {
    @Binding var volume: Double
    @Binding var selectedPlayer: Int
    var onInstructions: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 頂部紫色齒輪圖示
            Image(systemName: "gearshape.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color(red: 0.4, green: 0.0, blue: 1.0))
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 25) {
                // 音量控制
                HStack {
                    Text("音量").foregroundColor(.black).font(.headline).bold()
                    Slider(value: $volume, in: 0...100).accentColor(.black)
                    Text("\(Int(volume))").foregroundColor(.black).bold()
                }
                
                // 角色選擇
                HStack {
                    Text("角色").foregroundColor(.black).font(.headline).bold()
                    Spacer()
                    
                    // 藍色單選鈕
                    HStack(spacing: 12) {
                        Circle()
                            .fill(selectedPlayer == 1 ? Color.black : Color.clear)
                            .overlay(Circle().stroke(Color.black, lineWidth: 3))
                            .frame(width: 18, height: 18)
                        Image("player1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    }
                    .onTapGesture { selectedPlayer = 1 }
                    
                    Spacer()
                    
                    // 綠色單選鈕
                    HStack(spacing: 12) {
                        Circle()
                            .fill(selectedPlayer == 2 ? Color.black : Color.clear)
                            .overlay(Circle().stroke(Color.black, lineWidth: 3))
                            .frame(width: 18, height: 18)
                        Image("player2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                    }
                    .onTapGesture { selectedPlayer = 2 }
                }
                
                // 玩法按鈕
                HStack {
                    Text("玩法").foregroundColor(.black).font(.headline).bold()
                    Spacer()
                    Button(action: onInstructions) {
                        Text("遊戲說明")
                            .font(.subheadline).bold()
                            .foregroundColor(.white)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 10)
                            .background(Color(red: 0.4, green: 0.0, blue: 1.0))
                            .cornerRadius(20)
                    }
                }
            }
            .padding(30)
            .background(Color(red: 0.88, green: 0.88, blue: 0.88)) // 淺灰色面板
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(red: 0.4, green: 0.0, blue: 1.0), lineWidth: 4)
            )
            
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
        .padding(35)
        .background(Color.white)
        .cornerRadius(25)
        .frame(width: 550)
    }
}
