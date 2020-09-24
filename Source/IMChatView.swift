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
        
        bottomView.backgroundColor = .green
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
    }
}
