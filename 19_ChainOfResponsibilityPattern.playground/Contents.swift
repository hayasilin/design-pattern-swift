import UIKit
import Foundation

struct Message {
    let form: String
    let to: String
    let subject: String
}

//class LocalTransmitter {
//    func sendMessage(message: Message) {
//        print("Message to \(message.to) sent locally")
//    }
//}
//
//class RemoteTransmitter {
//    func sendMessage(message: Message) {
//        print("Message to \(message.to) sent remotely")
//    }
//}

//let messages = [Message(form: "amy@example.com", to: "joe@example.com", subject: "Free for lunch?"),
//                Message(form: "joe@example.com", to: "alice@acme.com", subject: "New contracts"),
//                Message(form: "pete@example.com", to: "all@example.com", subject: "Priority: All-hands meeting")]
//
//let localTransmitter = LocalTransmitter()
//let remoteTransmitter = RemoteTransmitter()
//
//for msg in messages {
//    if msg.to.hasSuffix("example.com") {
//        localTransmitter.sendMessage(message: msg)
//    } else {
//        remoteTransmitter.sendMessage(message: msg)
//    }
//}

// 以上問題在於使用傳輸物件來處理Message必須知道這些類別並認識何時該使用哪個，這樣會很難加入新訊息處理程序，並須改變現有處理關係
// 比如以下加入新傳輸類別PriorityTransmitter，就要新增class, 然後在for msg時，要多加一個判斷式來處理Priority的傳輸類

class Transmitter {
    var nextLink: Transmitter?

    required init() {

    }

    func sendMessage(message: Message) {
        if nextLink != nil {
            nextLink?.sendMessage(message: message)
        } else {
            print("End of chain reached. Message not sent")
        }
    }

    class func matchEmailSuffix(message: Message) -> Bool {
        return message.to.hasSuffix("example.com")
    }

    class func createChain() -> Transmitter? {
        let transmitterClasses: [Transmitter.Type] = [RemoteTransmitter.self,
                                                      LocalTransmitter.self,
                                                      PriorityTransmitter.self]

        var link: Transmitter?

        for tClass in transmitterClasses {
            let existingLink = link
            link = tClass.init()
            link?.nextLink = existingLink
        }

        return link
    }
}

class LocalTransmitter: Transmitter {
    override func sendMessage(message: Message) {
        if Transmitter.matchEmailSuffix(message: message) {
            print("Message to \(message.to) sent locally")
        } else {
            super.sendMessage(message: message)
        }
    }
}

class RemoteTransmitter: Transmitter {
    override func sendMessage(message: Message) {
        if !Transmitter.matchEmailSuffix(message: message) {
            print("Message to \(message.to) sent remotely")
        } else {
            super.sendMessage(message: message)
        }
    }
}

class PriorityTransmitter: Transmitter {
    override func sendMessage(message: Message) {
        if message.subject.lowercased().contains("priority") {
            print("Message to \(message.to) sent as priority")
        } else {
            super.sendMessage(message: message)
        }
    }
}

let messages = [Message(form: "amy@example.com", to: "joe@example.com", subject: "Free for lunch?"),
                Message(form: "joe@example.com", to: "alice@acme.com", subject: "New contracts"),
                Message(form: "pete@example.com", to: "all@example.com", subject: "Priority: All-hands meeting")]

let localTransmitter = LocalTransmitter()
let remoteTransmitter = RemoteTransmitter()

if let chain = Transmitter.createChain() {
    for msg in messages {
        chain.sendMessage(message: msg)
    }
}

// Chain of responibility pattern varitation
// Combine with factory method pattern

// Chain of responibility in Cocoa
// UIResponder
// 所有UI元件都繼承自UIResponder，鏈中的環是個別的UI元件，其排列反映介面元件的階層，鏈最後一環是最頂層的view
// 當使用者與元件互動時，例如點擊，Cocoa發送互動事件到代表被點擊元件的環，此元件有機會負責處理此事件，然後事件沿著鏈移動直到找到負責的元件或鏈的末端
// (這表示應用程式不想要或不虛處裡此事件並加以忽略)
