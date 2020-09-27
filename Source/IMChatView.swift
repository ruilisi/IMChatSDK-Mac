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
    let inputView = MessageTextField()
    let sendButton = XButton()
    
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
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
                                .init(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                                .init(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0),
                                .init(item: bottomView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
                                .init(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)])
        
        messageTable.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
                                .init(item: messageTable, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                                .init(item: messageTable, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                                .init(item: messageTable, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
                                .init(item: messageTable, attribute: .bottom, relatedBy: .equal, toItem: bottomView, attribute: .top, multiplier: 1, constant: 0)])
        
        bottomView.setBackgroundColor = NSColor(hex: 0xF0F4FA)
        
        setBottomView()
    }
    
    func setBottomView() {
        bottomView.addSubview(inputView)
        inputView.translatesAutoresizingMaskIntoConstraints = false
        inputView.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        inputView.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 10).isActive = true
        inputView.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.8).isActive = true
        inputView.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.67).isActive = true
        inputView.layoutSubtreeIfNeeded()
        
        bottomView.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -10).isActive = true
        sendButton.widthAnchor.constraint(equalTo: bottomView.widthAnchor, multiplier: 0.115).isActive = true
        sendButton.heightAnchor.constraint(equalTo: bottomView.heightAnchor, multiplier: 0.67).isActive = true
        
        sendButton.setLay(title: "发送", fontsize: 14, weight: .regular)
        sendButton.backAction = {
            self.sendClick()
        }
    }
    
    func sendClick() {
        if !inputView.stringValue.isEmpty {
            messageTable.sendMessage(message: inputView.stringValue)
            inputView.stringValue = ""
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
