//
//  MessageTextField.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/27.
//

import Cocoa

class MessageTextField: NSTextField {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        self.textColor = NSColor(hex: 0x333333)
        self.backgroundColor = NSColor(hex: 0xEBEBF0)
        self.focusRingType = .none     ///取消高亮
        self.autoresizesSubviews = true
        self.isBordered = false        ///无边框
        self.wantsLayer = true
        self.layer?.cornerRadius = 2
        self.lineBreakMode = .byCharWrapping
        self.usesSingleLineMode = false
        self.cell?.lineBreakMode = .byCharWrapping
        self.cell?.usesSingleLineMode = false
        
        self.placeholderAttributedString = NSAttributedString(
            string: "说点什么吧",
            attributes: [
                NSAttributedString.Key.foregroundColor: NSColor(hex: 0xABABAD)])
    }
    
    override func becomeFirstResponder() -> Bool {
        let flag = super.becomeFirstResponder()
        if flag {
            let tv = self.currentEditor()
            let newfiled = tv as! NSTextView
            newfiled.insertionPointColor = NSColor.black

        }
        return flag
    }
}
