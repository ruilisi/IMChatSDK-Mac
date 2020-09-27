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
    var sendEdge = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    var receiveEdge = NSEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.addSubview(scrollView)
        self.backgroundColor = .white
        
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
        messageTable.backgroundColor = .clear
        messageTable.headerView = nil
        messageTable.intercellSpacing = NSSize(width: 0, height: 10)
        
        let column = NSTableColumn()
        column.width = 300
        messageTable.addTableColumn(column)
        
        messageTable.focusRingType = .none
        messageTable.allowsTypeSelect = false
        messageTable.selectionHighlightStyle = .none
    }
    
    // MARK: 初始化SOCKET
    func build(config: UnifyDataConfig) {
        dataConfig = config
        isAlive = true
        print("isAlive: \(isAlive)")
        
        // 用户不一致，token过期
        if dataConfig.username != HistoryDataAccess.userName || timeNow - HistoryDataAccess.timeRecord > 10000000 {
            getData()
        } else {
            connectToWebSocket()
        }
    }
    
    // MARK: 获取连接参数
    func getData() {
        HttpUtil.post("https://api.chatsdk.io/customers/client_connect",
                     params: ["name": dataConfig.username,
                              "api_key": dataConfig.apiKey,
                              "department_id": dataConfig.departmentid],
                     header: [:],
                     onFailure: { value in
                        print(value)
        },
                     onSuccess: { value in
                        print(value)
                        HistoryDataAccess.userName = self.dataConfig.username
                        
                        // 用户变更
                        if value["id"].stringValue != self.dataConfig.userID {
                            HistoryDataAccess.historyData = []
                            self.cleanHistory()
                        }
                        
                        self.dataConfig.baseUrl = value["base"].stringValue.webSocketURL
                        self.dataConfig.userToken = value["token"].stringValue
                        self.dataConfig.roomID = value["rid"].stringValue
                        self.dataConfig.userID = value["id"].stringValue
                        self.dataConfig.wait = value["wait"].intValue
                        HistoryDataAccess.timeRecord = timeNow
                        self.connectToWebSocket()
        })
    }
    
    func connectToWebSocket() {
        if !HistoryDataAccess.historyData.isEmpty {
            if let action = completeAction { action() }
            if cells.isEmpty {
                insertHistory(data: HistoryDataAccess.historyData)
            }
        }
        
        socket = WebSocketHelper(baseurl: dataConfig.baseUrl)
        socket.delegate = self
    }
    
    // MARK: 清空历史
    func cleanHistory() {
        HistoryDataAccess.historyData = []
        cells = []
        self.messageTable.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UI Update
extension IMTableView {
    
    // MARK: 插入行
    func insertRow(message: MessageModel, desc: Bool = false, send: Bool = false, needhide: Bool = true) {
        let cell = MessageTableViewCell()
        var timeinterval = TimeInterval(message.timeInterval / 1000)
        if message.timeInterval == 0 {
            timeinterval = Date().timeIntervalSince1970
        }

        cell.sendEdge = sendEdge
        cell.receiveEdge = receiveEdge
        cell.sendBG = sendBG
        cell.receiveBG = receiveBG
        
        var hidetime = false
        
        hidetime = !needhide ? needhide : needHide(timeInterval: Int(timeinterval), desc: desc)
        
        cell.setContent(msgID: message.msgID, name: message.name, message: message.message, timeInterval: timeinterval, isSelf: message.bySelf, ishideTime: hidetime)
        
        if message.bySelf, send {
            cell.setLoading(isLoading: true)
        }
        
        DispatchQueue.main.async {
            self.addCellRow(cell: cell, desc: desc, byself: message.bySelf)
        }
    }
    
    func addCellRow(cell: MessageTableViewCell, desc: Bool, byself: Bool) {
        messageTable.beginUpdates()
        
        if !desc {
            cells.append(cell)
            messageTable.insertRows(at: IndexSet(integer: cells.count - 1), withAnimation: byself ? .slideRight : .slideLeft)
        } else {
            cells.insert(cell, at: 0)
            messageTable.insertRows(at: IndexSet(integer: 0), withAnimation: byself ? .slideRight : .slideLeft)
        }
        
        messageTable.endUpdates()
    }
    
    func needHide(timeInterval: Int, desc: Bool = false) -> Bool {
        var hidetime = false
        if cells.count >= 1 {
            if !desc {
                let time = cells[cells.count - 1].timeInt
                if timeInterval - time < dataConfig.timespan {
                    hidetime = true
                }
            } else {
                let time = cells[0].timeInt
                if time - timeInterval < dataConfig.timespan {
                    hidetime = true
                }
            }
        }
        return hidetime
    }
}

extension IMTableView: NSTableViewDelegate, NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        if row < cells.count {
            return cells[row].rowHeight
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if row < cells.count {
            return cells[row]
        }
        return nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return cells.count
    }
}
