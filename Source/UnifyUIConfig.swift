//
//  UnifyUIConfig.swift
//  eSheep
//
//  Created by 徐文杰 on 2020/9/11.
//  Copyright © 2020 Mauricio Cousillas. All rights reserved.
//

import Foundation

open class UnifyUIConfig {
    var backgroundColor: NSColor?
    var textColor: NSColor?
    var bottomColor: NSColor?
    var textbgColor: NSColor?
    var buttonColor: NSColor?
    var placeHolderColor: NSColor?
    var sendBG: NSImage?
    var sendEdge: NSEdgeInsets?
    var receiveBG: NSImage?
    var receiveEdge: NSEdgeInsets?
    
    public init() {
    }
    
    /**
     设置背景颜色
     - parameters:
        - color: 背景颜色
     */
    public func setBGColor(color: NSColor) -> UnifyUIConfig {
        backgroundColor = color
        return self
    }
    
    /**
     设置输入框文本颜色
     - parameters:
        - color: 文本颜色
     */
    public func setTextColor(color: NSColor) -> UnifyUIConfig {
        textColor = color
        return self
    }
    
    /**
     设置底部颜色
     - parameters:
        - color: 底部颜色
     */
    public func setBottomColor(color: NSColor) -> UnifyUIConfig {
        bottomColor = color
        return self
    }
    
    /**
     设置输入框背景颜色
     - parameters:
        - color: 背景颜色
     */
    public func setTextBGColor(color: NSColor) -> UnifyUIConfig {
        textbgColor = color
        return self
    }
    
    /**
     设置按钮的颜色
     - parameters:
        - color: 按钮颜色
     */
    public func setButtonColor(color: NSColor) -> UnifyUIConfig {
        buttonColor = color
        return self
    }
    
    /**
     设置占位符的颜色
     - parameters:
        - color: 文本颜色
     */
    public func setPlaceHolderColor(color: NSColor) -> UnifyUIConfig {
        placeHolderColor = color
        return self
    }
    
    /**
     设置发送消息气泡的的样式
     - parameters:
        - image: 气泡背景
        - edge: 图片拉伸边距
     */
    public func setSendBG(image: NSImage?, edge: NSEdgeInsets) -> UnifyUIConfig {
        sendBG = image
        sendEdge = edge
        return self
    }
    
    /**
     设置接收消息气泡的的样式
     - parameters:
        - image: 气泡背景
        - edge: 图片拉伸边距
     */
    public func setReceiveBG(image: NSImage?, edge: NSEdgeInsets) -> UnifyUIConfig {
        receiveBG = image
        receiveEdge = edge
        return self
    }
}