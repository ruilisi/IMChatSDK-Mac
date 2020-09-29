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
        
        self.textColor = NSColor(hex: 0x333333)
        self.backgroundColor = NSColor(hex: 0xFCFDFF)
        self.focusRingType = .none     ///取消高亮
        
        self.autoresizesSubviews = true
        self.wantsLayer = true
        self.layer?.cornerRadius = 2
    }
    
    override func becomeFirstResponder() -> Bool {
        
        let flag = super.becomeFirstResponder()
        if flag {
            let newfiled = self
            newfiled.insertionPointColor = NSColor.black
            
        }
        return flag
    }
}
