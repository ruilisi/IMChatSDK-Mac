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
    "然奥冲大餐掉欧塞onof诺达覅偶奇",
    "This is a test Label",
    "This is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test Label",
    "This is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test LabelThis is a test Label",
    "This is a test LabelThis is a test LabelThis is a test LabelThis is a test Label",
    "Ssss"]
