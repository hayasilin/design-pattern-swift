import UIKit
import Foundation

// MARK: - Prepare singleton pattern example

class DataItem {
    enum ItemType: String {
        case email = "Email address"
        case phone = "Telephone number"
        case card = "Credit card number"
    }

    var type: ItemType
    var data: String

    init(type: ItemType, data: String) {
        self.type = type
        self.data = data
    }
}

//class BackupServer {
//    let name: String
//    private var data = [DataItem]()
//    let logger = Logger()
//
//    init(name: String) {
//        self.name = name
//        logger.log(msg: "Created new server \(name)")
//    }
//
//    func backup(item: DataItem) {
//        data.append(item)
//        logger.log(msg: "\(name) backed up item of type \(item.type.rawValue)")
//    }
//
//    func getData() -> [DataItem] {
//        return data
//    }
//}
//
//class Logger {
//    private var data = [String]()
//
//    func log(msg: String) {
//        data.append(msg)
//    }
//
//    func printLog() {
//        for msg in data {
//            print("Log: \(msg)")
//        }
//    }
//}
//
//let logger = Logger()
//
//var server = BackupServer(name: "Server#1")
//server.backup(item: DataItem(type: .email, data: "joe@example.com"))
//server.backup(item: DataItem(type: .phone, data: "555-123-1133"))
//
//logger.log(msg: "Backed up 2 items to \(server.name)")
//
//var otherServer = BackupServer(name: "Server#2")
//otherServer.backup(item: DataItem(type: .email, data: "bobb@example.com"))
//
//logger.log(msg: "Backed up 1 item to \(otherServer.name)")
//
//logger.printLog()

// 問題，有個別2個Logger物件，分別維護了1組訊息，呼叫printLog()方法並不會輸出BackupServer裡保存的訊息，
// 我需要的是單一的Logger物件，可用來擷取所有除錯訊息並提供方法給程式找尋Logger物件而無需建構緊密的耦合

// MARK: - Singleton pattern implementation

// Quick singleton in Swift

//final class Logger {
//    private var data = [String]()
//
//    init() {
//        //不做任何動作，阻止其他檔案
//    }
//
//    func log(msg: String) {
//        data.append(msg)
//    }
//
//    func printLog() {
//        for msg in data {
//            print("Log: \(msg)")
//        }
//    }
//}
//
//let globalLogger = Logger()

//class BackupServer {
//    let name: String
//    private var data = [DataItem]()
//
//    init(name: String) {
//        self.name = name
//        globalLogger.log(msg: "Created new server \(name)")
//    }
//
//    func backup(item: DataItem) {
//        data.append(item)
//        globalLogger.log(msg: "\(name) backed up item of type \(item.type.rawValue)")
//    }
//
//    func getData() -> [DataItem] {
//        return data
//    }
//}
//
//var server = BackupServer(name: "Server#1")
//server.backup(item: DataItem(type: .email, data: "joe@example.com"))
//server.backup(item: DataItem(type: .phone, data: "555-123-1133"))
//
//globalLogger.log(msg: "Backed up 2 items to \(server.name)")
//
//var otherServer = BackupServer(name: "Server#2")
//otherServer.backup(item: DataItem(type: .email, data: "bobb@example.com"))
//
//globalLogger.log(msg: "Backed up 1 item to \(otherServer.name)")
//
//globalLogger.printLog()

// Traditional singleton pattern implementation

//class TraditionalBackupServer {
//    let name: String
//    private var data = [DataItem]()
//
//    private init(name: String) {
//        self.name = name
//        globalLogger.log(msg: "Created new server \(name)")
//    }
//
//    func backup(item: DataItem) {
//        data.append(item)
//        globalLogger.log(msg: "\(name) backed up item of type \(item.type.rawValue)")
//    }
//
//    func getData() -> [DataItem] {
//        return data
//    }
//
//    class var server: TraditionalBackupServer {
//        struct SingletonWrapper {
//            static let singleton = TraditionalBackupServer(name: "MainServer")
//        }
//        return SingletonWrapper.singleton
//    }
//}
//
//var server = TraditionalBackupServer.server
//server.backup(item: DataItem(type: .email, data: "joe@example.com"))
//server.backup(item: DataItem(type: .phone, data: "555-123-1133"))
//
//globalLogger.log(msg: "Backed up 2 items to \(server.name)")
//
//var otherServer = TraditionalBackupServer.server
//otherServer.backup(item: DataItem(type: .email, data: "bobb@example.com"))
//
//globalLogger.log(msg: "Backed up 1 item to \(otherServer.name)")
//
//globalLogger.printLog()

// MARK: - Thread safe implementation

final class Logger {
    private var data = [String]()
    private let arrayQ = DispatchQueue(label: "arrayQ")

    init() {
        //不做任何動作，阻止其他檔案
    }

    func log(msg: String) {
        arrayQ.sync {
            data.append(msg)
        }
    }

    func printLog() {
        for msg in data {
            print("Log: \(msg)")
        }
    }
}

let globalLogger = Logger()

class TraditionalBackupServer {
    let name: String
    private var data = [DataItem]()
    private let arrayQ = DispatchQueue(label: "arrayQ")

    private init(name: String) {
        self.name = name
        globalLogger.log(msg: "Created new server \(name)")
    }

    func backup(item: DataItem) {
        arrayQ.sync {
            data.append(item)
            globalLogger.log(msg: "\(name) backed up item of type \(item.type.rawValue)")
        }
    }

    func getData() -> [DataItem] {
        return data
    }

    class var server: TraditionalBackupServer {
        struct SingletonWrapper {
            static let singleton = TraditionalBackupServer(name: "MainServer")
        }
        return SingletonWrapper.singleton
    }
}

// MARK: - Singleton pattern in Cocoa
// UIApplication, sharedApplication
