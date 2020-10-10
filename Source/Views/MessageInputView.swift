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
    let lineView = NSView()
    
    var bgColor: NSColor {
        get {
            return textView.backgroundColor
        }

        set {
            textView.backgroundColor = newValue
        }
    }
    
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
        
        self.addSubview(lineView)
        self.addSubview(scrollView)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        lineView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        lineView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        lineView.setBackgroundColor = NSColor(hex: 0xCCCCCC)
        
//        scrollView.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
        scrollView.automaticallyAdjustsContentInsets = false
        scrollView.contentInsets = NSEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: lineView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        scrollView.documentView = textView
        scrollView.hasHorizontalScroller = false
        
//        textView.maxSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
        textView.isHorizontallyResizable = true
//        textView.textContainer?.widthTracksTextView = false
//        textView.textContainer?.containerSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
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
