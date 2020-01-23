import UIKit
import Foundation

// Prepare observer pattern example

//class ActivityLog {
//    func logActivity(activity: String) {
//        print("Log: \(activity)")
//    }
//}
//
//class FileCache {
//    func loadFiles(user: String) {
//        print("Load files for: \(user)")
//    }
//}
//
//class AttackMonitor {
//    var monitorSuspiciousActivity: Bool = false {
//        didSet {
//            print("Monitoring for attack: \(monitorSuspiciousActivity)")
//        }
//    }
//}

//class AuthenticationManager {
//    private let log = ActivityLog()
//    private let cache = FileCache()
//    private let monitor = AttackMonitor()
//
//    func authenticate(user: String, pass: String) -> Bool {
//        var result = false
//        if user == "bob" && pass == "secret" {
//            result = true
//            print("User \(user) is authenticated")
//            log.logActivity(activity: "Authenticated \(user)")
//            cache.loadFiles(user: user)
//            monitor.monitorSuspiciousActivity = false
//        } else {
//            print("Failed authentication attemp")
//            log.logActivity(activity: "Failed authentication: \(user)")
//            monitor.monitorSuspiciousActivity = true
//        }
//        return result
//    }
//}
//
//let authenticationManager = AuthenticationManager()
//authenticationManager.authenticate(user: "bob", pass: "secret")
//print("-----")
//authenticationManager.authenticate(user: "joe", pass: "shhh")

// MARK: - Observer pattern implementation

protocol Observer: class {
    func notify(user: String, success: Bool)
}

protocol Subject {
    func addObservers(observer: Observer...)
    func removeObserver(observer: Observer)
}

class SubjectBase: Subject {
    private var observers = [Observer]()

    func addObservers(observer: Observer...) {
        for object in observer {
            observers.append(object)
        }
    }

    func removeObserver(observer: Observer) {
        observers.filter{ $0 !== observer }
    }

    func sendNotification(user: String, success: Bool) {
        for object in observers {
            object.notify(user: user, success: success)
        }
    }
}

class ActivityLog: Observer {
    func notify(user: String, success: Bool) {
        print("Auth request for \(user). Success: \(success)")
    }

    func logActivity(activity: String) {
        print("Log: \(activity)")
    }
}

class FileCache: Observer {
    func notify(user: String, success: Bool) {
        if success {
            loadFiles(user: user)
        }
    }

    func loadFiles(user: String) {
        print("Load files for: \(user)")
    }
}

class AttackMonitor: Observer {
    func notify(user: String, success: Bool) {
        monitorSuspiciousActivity = !success
    }

    var monitorSuspiciousActivity: Bool = false {
        didSet {
            print("Monitoring for attack: \(monitorSuspiciousActivity)")
        }
    }
}

class AuthenticationManager: SubjectBase {
    func authenticate(user: String, pass: String) -> Bool {
        var result = false
        if user == "bob" && pass == "secret" {
            result = true
            print("User \(user) is authenticated")
        } else {
            print("Failed authentication attemp")
        }
        sendNotification(user: user, success: result)
        return result
    }
}

let log = ActivityLog()
let cache = FileCache()
let monitor = AttackMonitor()

let authenticationManager = AuthenticationManager()
authenticationManager.addObservers(observer: log, cache, monitor)

authenticationManager.authenticate(user: "bob", pass: "secret")
print("-----")
authenticationManager.authenticate(user: "joe", pass: "shhh")

// MARK: - Observer pattern in Cocoa
// NSNotificationCenter
// UIResponder - UIViewController's function: motionEnded()
// Key-value observing (KVO)

class TargetSubject: NSObject {
    dynamic var counter = 0
}

class KVOObserver: NSObject {
    init(targetSubject: TargetSubject) {
        super.init()
        targetSubject.addObserver(self, forKeyPath: "counter", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("Notification: \(String(describing: keyPath)) = \(String(describing: change![NSKeyValueChangeKey.newKey]))")
    }
}

let targetSubject = TargetSubject()
let observer = KVOObserver(targetSubject: targetSubject)
targetSubject.counter += 1
targetSubject.counter = 22
