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
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.isBezeled = false
        self.drawsBackground = false
        self.isEditable = false
        self.isSelectable = false
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
