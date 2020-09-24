//
//  ViewController.swift
//  IMChatSDK-Mac
//
//  Created by Thisismy0312 on 09/24/2020.
//  Copyright (c) 2020 Thisismy0312. All rights reserved.
//

import Cocoa
import IMChatSDK_Mac

class ViewController: NSViewController {
    
    let chatView = IMChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(chatView)
        chatView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
                                .init(item: chatView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)])
        
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

