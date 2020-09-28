//
//  PlaceholderTextView.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/28.
//

import Cocoa

class PlaceholderTextView: NSTextView {
    @objc var placeholderAttributedString: NSAttributedString?
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func becomeFirstResponder() -> Bool {
        self.needsDisplay = true
        return super.becomeFirstResponder()
    }
}
