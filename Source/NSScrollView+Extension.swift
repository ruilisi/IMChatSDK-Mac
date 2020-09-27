//
//  NSScrollView+Extension.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/27.
//

import Foundation

extension NSScrollView {
    public func scrollToBottom() {
        if let documentView = self.documentView {
            documentView.scroll(NSPoint(x: 0, y: 999999999))
        }
    }
}
