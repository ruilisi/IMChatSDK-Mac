//
//  NSLabel.swift
//  Lingti
//
//  Created by 徐文杰 on 2020/5/13.
//  Copyright © 2020 徐文杰. All rights reserved.
//

import Foundation
import Cocoa

open class NSLabel: NSTextField {
    
    var trackArea = NSTrackingArea.init()
    
    private var allowHove_ = false
    var allowHove: Bool {
        get {
            return allowHove_
        }
        set {
            allowHove_ = newValue
            setColor()
        }
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
        
        trackArea = NSTrackingArea.init(rect: self.bounds,
                                        options: [.mouseEnteredAndExited, .inVisibleRect, .assumeInside, .activeAlways],
                                        owner: self,
                                        userInfo: nil)
        self.addTrackingArea(trackArea)
    }
    
    open override func mouseEntered(with event: NSEvent) {
        if allowHove_ {
            self.alphaValue = 0.9
        }
    }
    
    open override func mouseExited(with event: NSEvent) {
        if allowHove_ {
            self.alphaValue = 0.7
        }
    }
    
    func setColor() {
        if allowHove_ {
            self.alphaValue = 0.7
        } else {
            self.alphaValue = 1
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
