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
    var dataconfig = UnifyDataConfig()
    
    let scrollView = NSScrollView()
    let textView = NSTextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.addSubview(scrollView)

//        scrollView.frame = CGRect(x: 0, y: 0, width: 500, height: 200)
//        scrollView.documentView = textView
//
//        scrollView.hasHorizontalScroller = true
//        textView.maxSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
//        textView.isHorizontallyResizable = true
//        textView.textContainer?.widthTracksTextView = false
//        textView.textContainer?.containerSize = NSMakeSize(.greatestFiniteMagnitude, .greatestFiniteMagnitude)
        setChatView()
    }
    
    func setChatView() {
        view.addSubview(chatView)
        
        chatView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
                                .init(item: chatView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0),
                                .init(item: chatView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1, constant: 0)])
        
        dataconfig = UnifyDataConfig()
            .setApiKey(key: "f6e873f72d5a465fae785d6143adb985")
            .setDepartmentID(did: "369d2d2b-f68b-4cf3-ba36-c588013fc511")
            .setUserName(uname: "Test2")
            .setWelcome(text: "你好傻逼")
            .setLoadHistoryCount(count: 10)
            .setPerLoadHistoryCount(count: 2)
            .setTimeSpan(timeinterval: 200)
        
        chatView.buildConnection(config: dataconfig, onSuccess: {
            print("FKING Success")
        }, onFailer: {
            print("Nice Try")
        })
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

