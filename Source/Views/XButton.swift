//
//  XButton.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/27.
//

import Cocoa

class XButton: NSButton {
    
    var trackArea = NSTrackingArea.init()
    var backAction: (() -> Void)?
    
    private var isHover_: Bool = false
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        trackArea = NSTrackingArea.init(rect: self.bounds,
                                        options: [.mouseEnteredAndExited, .inVisibleRect, .assumeInside, .activeAlways],
                                        owner: self,
                                        userInfo: nil)
        self.addTrackingArea(trackArea)
        self.wantsLayer = true
    }
    
    override func mouseDown(with event: NSEvent) {
        self.alphaValue = 0.5
        
        while true {
            guard let nextEvent = self.window?.nextEvent(matching: [.leftMouseUp, .leftMouseDragged]) else { continue }
            let mouseLocation = self.convert(nextEvent.locationInWindow, from: nil)
            let isInside = self.bounds.contains(mouseLocation)
            
            switch nextEvent.type {
            case .leftMouseUp:
                self.alphaValue = 1
                if isInside {
                    mouseUpImpl(with: nextEvent)
                }
                return
                
            default: break
            }
        }
    }
    
    func mouseUpImpl(with event: NSEvent) {
        if let callback = backAction { callback() }
    }
    
    func setLay( title: String, fontsize: CGFloat, weight: NSFont.Weight) {
        setTitle(title, fontsize, weight)
        
        self.wantsLayer = true
        self.isBordered = false
        self.layer?.backgroundColor = NSColor(hex: 0x397FDF).cgColor
        self.font = font
        self.layer?.cornerRadius = 2
        self.layer?.masksToBounds = true
    }
    
    func setTitle(_ title: String, _ fontsize: CGFloat, _ weight: NSFont.Weight) {

        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        attributedTitle = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.foregroundColor :#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            NSAttributedString.Key.font: NSFont.systemFont(ofSize: fontsize, weight: weight),
            NSAttributedString.Key.paragraphStyle: paragraph])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

