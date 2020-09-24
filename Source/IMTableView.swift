//
//  IMTableView.swift
//  IMChatSDK-Mac
//
//  Created by 徐文杰 on 2020/9/24.
//

import Cocoa
import Starscream
import SwiftyJSON

enum HistoryTimeInterval {
    case latest
    case none
}

class IMTableView: NSView {
    
    var socket = WebSocketHelper()
    let scrollView = NSScrollView()
    let messageTable = NSTableView()
    var retryCount = 0
    var sendingList: [[String]] = []
    var lossConnect: Bool = false
    var isAlive: Bool = false
    var lossTimeInterval: Int = 0
    var cells: [MessageTableViewCell] = []
    var testcells: [NSView] = []
    var errorAction: (() -> Void)?
    var completeAction: (() -> Void)?
    var dataConfig = UnifyDataConfig()
    
    var sendBG = NSImage(named: "bgSend")
    var receiveBG = NSImage(named: "bgReceive")
    var sendEdge = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    var receiveEdge = NSEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([
                                .init(item: scrollView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0),
                                .init(item: scrollView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0),
                                .init(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0),
                                .init(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)])
        
        scrollView.documentView = messageTable
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.allowsColumnSelection = false
        messageTable.headerView = nil
        messageTable.intercellSpacing = NSSize(width: 0, height: 10)
        
        messageTable.focusRingType = .none
        messageTable.allowsTypeSelect = false
        messageTable.selectionHighlightStyle = .none
        
        for (index, _) in datas.enumerated() {
            let cell = NSView()
//            cell.setContent(msgID: "123123", name: "123123", message: item, timeInterval: 100000200, isSelf: index % 2 == 0 , ishideTime: true)
            cell.backgroundColor = index % 2 == 0 ? .blue : .yellow
            testcells.append(cell)
        }
        messageTable.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IMTableView: NSTableViewDelegate, NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let res = testcells[row]
        return res
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return testcells.count
    }
}
