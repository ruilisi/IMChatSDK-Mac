public let screenWidth = NSScreen.main?.frame.width
public let screenHeight = NSScreen.main?.frame.height
public let unmistakableChars
 = "23456789ABCDEFGHJKLMNPQRSTWXYZabcdefghijkmnopqrstuvwxyz"

public let timeNow = Int(Date().timeIntervalSince1970) * 1000

// MARK: - 随机生成ID
func createID(_ seed: String = unmistakableChars) -> String {
    let count = seed.count
    var result = ""
    for _ in 0 ..< 17 {
        let chart = seed[Int.random(in: 0..<count)]
        result += chart
    }
    return result
}

public let datas: [String] = [
    "11111",
    "222222222222222",
    "333333333333333333333333333",
    "4444444444444444444444444444444444",
    "55555555555555555555555555555555555555555",
    "Ssss"]
