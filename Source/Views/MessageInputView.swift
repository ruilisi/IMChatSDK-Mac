//
//  MessageInputView.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/30.
//

import Cocoa

class MessageInputView: NSView {
    
    let scrollView = NSScrollView()
    let textView = PlaceholderTextView()
    
    var string: String {
        get {
            return textView.string
        }
        
        set {
            textView.string = newValue
        }
    }
    
    var placeholderAttributedString: NSAttributedString? {
        get {
            return textView.placeholderAttributedString
        }
        
        set {
            textView.placeholderAttributedString = newValue
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.addSubview(scrollView)
        
        textView.textColor = NSColor(hex: 0x333333)
        textView.backgroundColor = NSColor(hex: 0xFCFDFF)
        textView.focusRingType = .none     ///取消高亮
        
        textView.autoresizesSubviews = true
        textView.wantsLayer = true
        textView.layer?.cornerRadius = 2
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        scrollView.documentView = textView
        
        scrollView.hasHorizontalScroller = true
        textView.maxSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
        textView.isHorizontallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WhiteInputView: NSTextView {
    
    @objc var placeholderAttributedString: NSAttributedString?
    
    override func becomeFirstResponder() -> Bool {
        let flag = super.becomeFirstResponder()
        if flag {
            let newfiled = self
            newfiled.insertionPointColor = NSColor.black
            
        }
        return flag
    }
}
