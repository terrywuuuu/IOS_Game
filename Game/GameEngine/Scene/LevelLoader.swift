import Foundation

class LevelLoader {
    static func load(name: String) -> LevelData? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json")
        else {
            return nil
        }

        do {
            let data = try Data(contentsOf: url)

            return try JSONDecoder().decode(
                LevelData.self,
                from: data
            )
        }
        catch {
            print(error)
            return nil
        }
    }
}