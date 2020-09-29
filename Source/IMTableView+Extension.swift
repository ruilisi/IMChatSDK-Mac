//
//  IMTableView+Extension.swift
//  eSheep
//
//  Created by 徐文杰 on 2020/9/10.
//  Copyright © 2020 Mauricio Cousillas. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

// MARK: - WebSocket Handler
extension IMTableView: WebSocketDelegate {
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            socket.isConnected = true
            print("websocket is connected: \(headers)")
            connected()
        case .disconnected(let reason, let code):
            socket.isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
            handleMessage(string)
        case .binary(let data):
            print("Received data: \(data.count)")
        case .cancelled:
            socket.isConnected = false
        case .error(let error):
            socket.isConnected = false
            handleError(error)
        case .viabilityChanged(let state):
            viabilityChange(state: state)
        default:
            break
        }
    }
    
    func viabilityChange(state: Bool) {
        print("WebSocket State:\(state)")
        if !state {
            lossConnect = true
            if lossTimeInterval == 0 {
                lossTimeInterval = Int(Date().timeIntervalSince1970) * 1000
            }
        } else {
            if lossConnect {
                connectionToServer()
            }
        }
    }
    
    // MARK: 连接服务器
    func connectionToServer(token: String? = nil) {
        if let value = token {
            dataConfig.userToken = value
        }
        socket.connectServer(config: dataConfig)
        socket.loginServer()
        socket.subServer()
    }
    
    // MARK: 成功连接
    func connected() {
        if socket.socket == nil {
            if let error = errorAction { error() }
            return
        } else {

            if let action = completeAction {
                print("Connect Complete")
                action()
            }
            
            connectionToServer()
            if lossConnect {
                socket.getMissHistory(dataConfig.roomID, lossTimeInterval)
            } else {
                if HistoryDataAccess.historyData.isEmpty {
                    getHistory(type: .none, count: dataConfig.loadCount)
                } else {
                    socket.getMissHistory(dataConfig.roomID, HistoryDataAccess.historyData.last?.timeInterval ?? 0)
                }
            }
            
            if !sendingList.isEmpty {
                socket.sendMsg(sendingList[0][0], sendingList[0][1], dataConfig.roomID)
            }
        }
    }
    
    // MARK: 断开连接
    func disconnect() {
        isAlive = false
        print("isAlive:\(isAlive)")
        socket.disconnectFromServer()
    }
    
    
    // MARK: 插入历史消息
    func insertHistory(data: [MessageModel]) {
        for item in data {
            insertRow(message: item)    //插入到第0行
        }
    }
    
    // MARK: 尝试重新连接服务器
    func reconnectServer() {
        retryCount += 1
        print("Connection Faild, reconnecting: \(retryCount)")
        socket = WebSocketHelper(baseurl: dataConfig.baseUrl)
        socket.delegate = self
    }
    
    // MARK: 处理异常
    func handleError(_ error: Error?) {
        print("WebSocket Error: \(error)")
        guard let err = error else { return }
        let errordata = err as NSError
        print("IM Error Message Code: \"\(errordata.code)\", Reason: \"\(errordata.localizedFailureReason ?? "nil")\"")
        
        if ![0, 1, 2, 3].contains(errordata.code) {
//            if let action = errorAction { action() }
        }
        
//        if errordata.code == 50 {
            lossConnect = true
            
            if lossTimeInterval == 0 {
                lossTimeInterval = Int(Date().timeIntervalSince1970) * 1000
            }
//        }
        
        guard isAlive else { return }
        
        let seconds = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.reconnectServer()
        }
    }
}

// MARK: - 接收
extension IMTableView {
    
    // MARK: 消息处理
    func handleMessage(_ msg: String) {
        let jsondata = JSON(parseJSON: msg)
        
        let type = jsondata["msg"].stringValue
        
        if type == "result" {
            if let list = jsondata["result"]["messages"].array {
                historyHandel(list: list)
            } else if let list = jsondata["result"].array {
                insertMissingMessage(list: list)
            }
        }
        
        if type == "changed" {
            let data = jsondata["fields"]
            receiveMessage(data: data)
        }
        
        return
    }
    
    // MARK: 历史消息处理
    func historyHandel(list: [JSON]) {
        
        var datalist: [MessageModel] = []
        
        for item in list {
            let message = MessageModel(
                msgID: item["_id"].stringValue,
                name: item["u"]["name"].stringValue,
                message: item["msg"].stringValue,
                timeInterval: item["_updatedAt"]["$date"].intValue,
                roomID: item["rid"].stringValue,
                bySelf: item["u"]["_id"].stringValue == dataConfig.userID)
            datalist.append(message)
        }
        
        var data: [MessageModel] = []
        
        if datalist.isEmpty, cells.isEmpty {
            let defaultmessage = MessageModel(
                msgID: "",
                name: "",
                message: dataConfig.welcomText,
                timeInterval: Int(Date().timeIntervalSince1970) * 1000,
                roomID: dataConfig.roomID,
                bySelf: false)
            data.append(defaultmessage)
        } else {
            data = datalist.sorted {
                $0.timeInterval > $1.timeInterval
            }
        }
        
        for (index, item) in data.enumerated() {
            insertRow(message: item, desc: true, needhide: index != data.count - 1)    //插入到第0行
            HistoryDataAccess.insertMessage(messag: item)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            historyFlag = true
        }
        
        return
    }
    
    // MARK: 收到消息
    func receiveMessage(data: JSON) {
        if let msgs = data["args"].array, !msgs.isEmpty {
            for item in msgs {
                let message = MessageModel(
                    msgID: item["_id"].stringValue,
                    name: item["u"]["username"].stringValue,
                    message: item["msg"].stringValue,
                    timeInterval: item["ts"]["$date"].intValue,
                    roomID: item["rid"].stringValue,
                    bySelf: item["u"]["_id"].stringValue == dataConfig.userID)
                
                let sameMSG = HistoryDataAccess.historyData.filter{ $0.msgID == message.msgID }
                guard sameMSG.isEmpty else { continue }
                
                HistoryDataAccess.appendMessage(message: message)
                guard !message.msgID.isEmpty else { continue }
                
                if let index = sendingList.firstIndex(of: [message.msgID, message.message]) {
                    sendingList.remove(at: index)
                }
                
                print("afterSendingList:\(sendingList)")
                
                let cell = cells.first(where: { $0.messageID == message.msgID })
                if let msgcell = cell {
                    msgcell.setLoading(isLoading: false)
                } else {
                    insertRow(message: message)
                }
                
            }
            
            sendNext()
        }
    }
    
    // MARK: 插入丢失新的信息
    func insertMissingMessage(list: [JSON]) {
        lossConnect = false
        lossTimeInterval = 0
        
        var datalist: [MessageModel] = []
        
        for item in list {
            let message = MessageModel(
                msgID: item["_id"].stringValue,
                name: item["u"]["name"].stringValue,
                message: item["msg"].stringValue,
                timeInterval: item["_updatedAt"]["$date"].intValue,
                roomID: item["rid"].stringValue,
                bySelf: item["u"]["_id"].stringValue == dataConfig.userID)
            datalist.append(message)
        }
        
        let data = datalist.sorted {
            $0.timeInterval < $1.timeInterval
        }
        
        print("Missing Message: \(datalist)")
        
        for item in data {
            insertRow(message: item)
            HistoryDataAccess.appendMessage(message: item)
        }
    }
}


// MARK: - 发送
extension IMTableView {
    
    // MARK: 发送下一条
    func sendNext() {
        if !sendingList.isEmpty {
            self.socket.sendMsg(sendingList[0][0], sendingList[0][1], dataConfig.roomID)
        }
    }
    
    // MARK: 按数量获取历史消息
    func getHistory(type: HistoryTimeInterval, count: Int) {
        
        var timeInterval: Int?
        
        switch type {
        case .none:
            break
        case .latest:
            guard !cells.isEmpty else { break }
            timeInterval = cells[0].timeInt * 1000
        }
        
        socket.getHistory(dataConfig.roomID, count, timeInterval)
    }
    
    // MARK: - 发送消息
    func sendMessage(message: String) {
        
        let msgID = Helper.createID()
        
        let msg = MessageModel(
            msgID: msgID,
            name: "",
            message: message,
            timeInterval: Int(Date().timeIntervalSince1970) * 1000,
            roomID: dataConfig.roomID,
            bySelf: true)
        
        insertRow(message: msg, send: true)
        
        sendingList.append([msgID, message])
        
        if sendingList.count == 1 {
            socket.sendMsg(sendingList[0][0], sendingList[0][1], dataConfig.roomID)
        }
        
        print("befaoreSendingList:\(sendingList)")
    }
}
