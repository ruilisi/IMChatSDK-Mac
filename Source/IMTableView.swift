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
                                .init(item: scrollView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0),
                                .init(item: scrollView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)])
        
        scrollView.documentView = messageTable
        scrollView.drawsBackground = false
        
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.allowsColumnSelection = false
        messageTable.headerView = nil
        messageTable.intercellSpacing = NSSize(width: 0, height: 10)
        
        let column = NSTableColumn()
        column.width = 300
        messageTable.addTableColumn(column)
        
        messageTable.focusRingType = .none
        messageTable.allowsTypeSelect = false
        messageTable.selectionHighlightStyle = .none
        
        for (index, item) in datas.enumerated() {
            let cell = MessageTableViewCell()
            cell.setContent(msgID: "123123", name: "123123", message: item, timeInterval: 100000200, isSelf: index % 2 == 0 , ishideTime: true)
            cells.append(cell)
        }
        messageTable.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IMTableView: NSTableViewDelegate, NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        print("RowHeight: \(cells[row].rowHeight)")
        return cells[row].rowHeight
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        return cells[row]
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cells.count
    }
}
