//
//  IMChatView.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/24.
//

import Cocoa

open class IMChatView: NSView {
    
    let messageTable = IMTableView()
    let bottomView = NSView()
    var inputView = MessageInputView()
    let scView = NSScrollView()
    let sendButton = XButton()
    var bottomViewAnchor = NSLayoutConstraint()
    
    var completeAction: (() -> Void)? {
        get {
            return messageTable.completeAction
        }
        
        set {
            messageTable.completeAction = newValue
        }
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.addSubview(bottomView)
        self.addSubview(messageTable)
        self.addSubview(sendButton)
        self.addSubview(scView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        bottomView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        messageTable.translatesAutoresizingMaskIntoConstraints = false
        messageTable.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        messageTable.bottomAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        messageTable.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        messageTable.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        
        setBottomView()
    }
    
    func setBottomView() {
        bottomView.addSubview(inputView)
//        bottomView.heightAnchor.constraint(equalTo: inputView.heightAnchor, constant: 20).isActive = true
        
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        inputView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        inputView.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        inputView.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        inputView.textView.delegate = self
        inputView.placeholderAttributedString = NSAttributedString(
            string: "说点什么吧",
            attributes: [
                NSAttributedString.Key.foregroundColor: NSColor(hex: 0xABABAD)])
        inputView.bgColor = NSColor(hex: 0xEBEBF0)
//
//        bottomView.addSubview(sendButton)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
//        sendButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10).isActive = true
//        sendButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.115).isActive = true
//        sendButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
//        sendButton.setLay(title: "发送", fontsize: 14, weight: .regular)
//        sendButton.backAction = {
//            self.sendClick()
//        }
    }
    
    func sendMessage() {
        if !inputView.string.isEmpty {
            messageTable.sendMessage(message: inputView.string)
            inputView.string = ""
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public extension IMChatView {
    
    /**
     配置连接
     - parameters:
        - config: 配置信息
        - onSuccess: 连接成功回调
        - onFailer: 连接失败回调
     */
    func buildConnection(config: UnifyDataConfig, onSuccess: (() -> Void)? = nil, onFailer: (() -> Void)? = nil) {
        completeAction = onSuccess
        messageTable.errorAction = onFailer
        messageTable.build(config: config)
    }
}

extension IMChatView: NSTextViewDelegate {
    public func textView(_ textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        
        if commandSelector == #selector(NSStandardKeyBindingResponding.insertNewline(_:)) {
            sendMessage()
            return true
        }
        return false
    }
}
