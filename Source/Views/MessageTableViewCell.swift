//
//  MessageTableViewCell.swift
//  eSheep
//
//  Created by 徐文杰 on 2020/8/28.
//  Copyright © 2020 Mauricio Cousillas. All rights reserved.
//

import Lottie

class MessageTableViewCell: NSView {

    let label = NSLabel()
    let time = NSLabel()
    let bgimage = NSImageView()
    let loadingLottie = AnimationView(name: "msgloading", bundle: Resources.bundle, imageProvider: nil, animationCache: nil)
    
    var timeInt = Int()
    var messageID = String()

    var sendBG = NSImage(named: "bgSend")
    var receiveBG = NSImage(named: "bgReceive")
    
    var labelfont = NSFont()
    
    var sendEdge = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var receiveEdge = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    var rowHeight = CGFloat()
    
    private var hideTime: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        addSubview(bgimage)
        addSubview(label)
        addSubview(loadingLottie)
        loadingLottie.isHidden = true
        loadingLottie.loopMode = .loop
        loadingLottie.backgroundBehavior = .pauseAndRestore
        
        backgroundColor = .clear
        label.textColor = .white
        time.textColor = NSColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        
        if #available(OSX 10.11, *) {
            labelfont = NSFont.systemFont(ofSize: 20, weight: .regular)
            time.font = NSFont.systemFont(ofSize: 13, weight: .regular)
        } else {
            // Fallback on earlier versions
            labelfont = NSFont.systemFont(ofSize: 20)
            time.font = NSFont.systemFont(ofSize: 13)
        }
        label.font = labelfont
    }
    
    func setSendImg(image: NSImage, edge: NSEdgeInsets) {
        sendBG = image
        sendEdge = edge
    }
    
    func setReceivImg(image: NSImage, edge: NSEdgeInsets) {
        receiveBG = image
        receiveEdge = edge
    }
    
    // MARK: - Set Content
    func setContent(msgID: String, name: String, message: String, timeInterval: TimeInterval, isSelf: Bool = false, ishideTime: Bool = false) {
        messageID = msgID
        timeInt = Int(timeInterval)
        label.stringValue = "\(message)"
        
        
        label.frame = getLabelSize(text: message, attributes: [.font: label], textWidth: Int(vWidth * 0.6))
        
        let labelWidth = label.frame.width
        let labelHeight = label.frame.height
        var timebottom: CGFloat = 0
        
        let bgWidth = labelWidth + 40
        let bgHeight = CGFloat.maximum(labelHeight + 24, 44)
        
        print("size of :\"\(message)\" is : Width \(labelWidth) Height: \(labelHeight)")
        
        hideTime = ishideTime
        
        if !ishideTime {
            addSubview(time)
            time.stringValue = getTimeStringByCurrentDate(timeInterval: timeInterval)
            time.frame = CGRect(x: 0, y: 0, width: vWidth, height: 15)
            time.alignment = .center
            timebottom = 17
        }
        
        if !isSelf {
            receiveBG?.resizingMode = .stretch
            receiveBG?.capInsets = receiveEdge
            bgimage.image = receiveBG
            
            bgimage.frame = CGRect(x: 10, y: timebottom, width: bgWidth, height: bgHeight)
            label.frame = CGRect(x: 30, y: (bgimage.bounds.height - labelHeight) * 0.5 + timebottom, width: labelWidth, height: labelHeight)
            rowHeight = bgimage.bottom + 20.0
        } else {
            sendBG?.resizingMode = .stretch
            sendBG?.capInsets = sendEdge
            bgimage.image = sendBG
            
            bgimage.frame = CGRect(x: vWidth - bgWidth - 10, y: timebottom, width: bgWidth, height: bgHeight)
            label.frame = CGRect(x: bgimage.frame.origin.x + 20, y: (bgimage.bounds.height - labelHeight) * 0.5 + timebottom, width: labelWidth, height: labelHeight)
            rowHeight = bgimage.bottom + 20.0
            
            loadingLottie.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                .init(item: loadingLottie, attribute: .trailing, relatedBy: .equal, toItem: bgimage, attribute: .leading, multiplier: 1, constant: -10),
                .init(item: loadingLottie, attribute: .bottom, relatedBy: .equal, toItem: bgimage, attribute: .bottom, multiplier: 1, constant: 0),
                .init(item: loadingLottie, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25),
                .init(item: loadingLottie, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
        }
    }
    
    func getTimeStringByCurrentDate(timeInterval: TimeInterval) -> String {
        
        let dateVar = Date.init(timeIntervalSince1970: timeInterval)
        let dateFormatter = DateFormatter()
        
        let calender = NSCalendar.current
        if calender.isDateInYesterday(dateVar) {
            dateFormatter.dateFormat = "昨天 hh:mm"
        } else if calender.isDateInToday(dateVar) {
            dateFormatter.dateFormat = "今天 hh:mm"
        } else {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
        }
        
        return dateFormatter.string(from: dateVar)
    }
    
    func setLoading(isLoading: Bool = true) {
        time.isHidden = hideTime ? true : isLoading
        loadingLottie.isHidden = !isLoading
        
        if isLoading {
            loadingLottie.play()
        } else {
            loadingLottie.pause()
        }
    }
    
    private func getLabelSize(text: String, attributes: [NSAttributedString.Key: Any], textWidth: Int) -> CGRect {
        
        var size = CGRect()
        
        //设置label最大宽度
        let size2 = CGSize(width: textWidth, height: 0)
        
        size = (text as NSString).boundingRect(with: size2, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return size

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
