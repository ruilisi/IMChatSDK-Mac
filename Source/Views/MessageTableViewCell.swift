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
    let loadingLottie = AnimationView(name: "msgloading")
    
    var timeInt = Int()
    var messageID = String()

    var sendBG = NSImage(named: "bgSend")
    var receiveBG = NSImage(named: "bgReceive")
    
    var labelfont = NSFont()
    
    var sendEdge = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    var receiveEdge = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    
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
        
        setBackgroundColor = .clear
        time.textColor = NSColor(hex: 0x000000, alpha: 0.5)
        
        labelfont = NSFont.systemFont(ofSize: 14, weight: .regular)
        time.font = NSFont.systemFont(ofSize: 12, weight: .regular)
        
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
        
        
        label.cell?.usesSingleLineMode = false
        label.cell?.wraps = true
        label.cell?.lineBreakMode = .byCharWrapping
        
        hideTime = ishideTime
        bgimage.imageScaling = .scaleAxesIndependently
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: bgimage.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: bgimage.centerXAnchor).isActive = true
        label.widthAnchor.constraint(lessThanOrEqualToConstant: 400).isActive = true
//        label.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.7).isActive = true

        label.lineBreakMode = .byCharWrapping
        label.usesSingleLineMode = false
        label.layoutSubtreeIfNeeded()
        
        bgimage.translatesAutoresizingMaskIntoConstraints = false
        bgimage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        bgimage.widthAnchor.constraint(equalTo: label.widthAnchor, constant: 12).isActive = true
        bgimage.heightAnchor.constraint(equalTo: label.heightAnchor, constant: 12).isActive = true
        
        if !isSelf {
            receiveBG?.resizingMode = .stretch
            receiveBG?.capInsets = receiveEdge
            bgimage.image = receiveBG
            
            label.textColor = NSColor(hex: 0x333333)
            bgimage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        } else {
            sendBG?.resizingMode = .stretch
            sendBG?.capInsets = sendEdge
            bgimage.image = sendBG
            bgimage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
            
            label.textColor = .white
            loadingLottie.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints([
                .init(item: loadingLottie, attribute: .trailing, relatedBy: .equal, toItem: bgimage, attribute: .leading, multiplier: 1, constant: -10),
                .init(item: loadingLottie, attribute: .bottom, relatedBy: .equal, toItem: bgimage, attribute: .bottom, multiplier: 1, constant: 0),
                .init(item: loadingLottie, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25),
                .init(item: loadingLottie, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 25)])
        }
        
        bgimage.layoutSubtreeIfNeeded()
        
        if !ishideTime {
            addSubview(time)
            time.stringValue = getTimeStringByCurrentDate(timeInterval: timeInterval)
            time.frame = CGRect(x: 0, y: bgimage.frame.height + 10.0, width: vWidth, height: 15)
            time.alignment = .center
            
            time.translatesAutoresizingMaskIntoConstraints = false
            time.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            time.bottomAnchor.constraint(equalTo: bgimage.topAnchor).isActive = true
            time.layoutSubtreeIfNeeded()
        }
        
        rowHeight = bgimage.frame.height + time.frame.height
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
//
        size = (text as NSString).boundingRect(with: size2, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return size

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
