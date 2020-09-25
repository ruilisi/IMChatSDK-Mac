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
    "您好，有什么可以帮到您的吗？",
    "您好，我想白嫖。",
    "亲爱的用户，您好，我是你爹，信不信我把你牛子扯下来挂在你家门口？",
    "那我包年可以吧？",
    "爸爸你好，我们将为您提供全世界最好的牛子按摩服务，请问您想要哪一位技师？",
    "贾琳。"]
