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
        setinit()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setinit()
    }
    
    func setinit() {
        
        self.textColor = NSColor(hex: 0x333333)
        self.backgroundColor = NSColor(hex: 0xFCFDFF)
//        self.backgroundColor = .red
        self.focusRingType = .none     ///取消高亮
        
        self.autoresizesSubviews = true
//        delegate = self
    }
    
    override init(frame frameRect: NSRect, textContainer container: NSTextContainer?) {
        super.init(frame: frameRect, textContainer: container)
        setinit()
    }
    override func becomeFirstResponder() -> Bool {
        
        let flag = super.becomeFirstResponder()
        if flag {
            let newfiled = self
            newfiled.insertionPointColor = NSColor.black
            
        }
        return flag
    }
    
//    override var intrinsicContentSize: NSSize {
//        guard let manager = textContainer?.layoutManager else {
//            return .zero
//        }
//        
//        manager.ensureLayout(for: textContainer!)
//        
//        var size = manager.usedRect(for: textContainer!).size
//        
//        if size.height > 100 {
//            size = CGSize(width: size.width, height: 100)
//        } else if size.height < 30 {
//            size = CGSize(width: size.width, height: 30)
//        }
//        
//        print("Current textviewsize:\(size)")
//        return size
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceholderTextView: NSTextViewDelegate {
    func textDidChange(_ notification: Notification) {
        invalidateIntrinsicContentSize()
    }
}
