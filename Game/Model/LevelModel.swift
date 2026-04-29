import Foundation

struct LevelData: Decodable {
    let levelWidth:Int
    let background:String

    let playerSpawn:Spawn

    let grounds:[Ground]

    let platforms:[Platform]

    let enemies:[EnemyData]

    let spikes:[Spike]

    let coins:[Coin]

    let items:[ItemData]

    let checkpoints:[Checkpoint]

    let goal:Goal
}

struct Spawn:Decodable{
    let x:CGFloat
    let y:CGFloat
}

struct Ground:Decodable{
    let x:CGFloat
    let y:CGFloat
    let width:CGFloat
    let height:CGFloat
    let texture:String
}

struct Platform:Decodable{
    let x:CGFloat
    let y:CGFloat
    let width:CGFloat
    let height:CGFloat
}

struct EnemyData:Decodable{
    let type:String
    let x:CGFloat
    let y:CGFloat
}

struct Spike:Decodable{
    let x:CGFloat
    let y:CGFloat
}

struct Coin:Decodable{
    let x:CGFloat
    let y:CGFloat
}

struct ItemData:Decodable{
    let type:String
    let x:CGFloat
    let y:CGFloat
}

struct Checkpoint:Decodable{
    let x:CGFloat
    let y:CGFloat
}

struct Goal:Decodable{
    let x:CGFloat
    let y:CGFloat
}