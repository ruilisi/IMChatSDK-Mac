//
//  IMChatSDK.swift
//  IMChatSDK
//
//  Created by 徐文杰 on 2020/9/15.
//

import Foundation


fileprivate class ThisClass {}

public struct Resources {
    public static var bundle: Bundle {
        let path = Bundle(for: ThisClass.self).resourcePath! + "/IMChatSDK-Mac.bundle"
        return Bundle(path: path)!
    }
}
