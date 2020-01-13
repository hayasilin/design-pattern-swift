import Foundation
import UIKit

// 嘗試整合第三方元件時不要使用此模式，請使用adapter pattern

protocol ClearMessageChannel {
    func send(message: String)
}

protocol SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String)
}

protocol PriorityMessageChannel {
    func sendPriority(message: String)
}

class Communicator {
    private let clearChannel: ClearMessageChannel
    private let secureChannel: SecureMessageChannel
    private let priorityChannel: PriorityMessageChannel

    init(clearChannel: ClearMessageChannel, secureChannel: SecureMessageChannel, priorityChannel: PriorityMessageChannel) {
        self.clearChannel = clearChannel
        self.secureChannel = secureChannel
        self.priorityChannel = priorityChannel
    }

    func sendClearTextMessage(message: String) {
        self.clearChannel.send(message: message)
    }

    func sendSecureMessage(message: String) {
        self.secureChannel.sendEncryptedMessage(encryptedText: message)
    }

    func sendPriorityMessage(message: String) {
        self.priorityChannel.sendPriority(message: message)
    }
}

class Landline: ClearMessageChannel {
    func send(message: String) {
        print("Landline: \(message)")
    }
}

class SecureLandline: SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String) {
        print("Secure Landline: \(encryptedText)")
    }
}

class Wireless: ClearMessageChannel {
    func send(message: String) {
        print("Landline: \(message)")
    }
}

class SecureWireless: SecureMessageChannel {
    func sendEncryptedMessage(encryptedText: String) {
        print("Secure Landline: \(encryptedText)")
    }
}

//var clearChannel = Landline()
//var secureChannel = SecureLandline()
//var comms = Communicator(clearChannel: clearChannel, secureChannel: secureChannel)
//
//comms.sendClearTextMessage(message: "Hello")
//comms.sendSecureMessage(message: "This is a secret")

protocol Message {
    var contentToSend: String { get }
    init(message: String)
    func prepareMessage()
}

class ClearMessage: Message {
    private var message: String

    required init(message: String) {
        self.message = message
    }

    func prepareMessage() {

    }

    var contentToSend: String {
        return message
    }
}

class EncryptedMessage: Message {
    private var clearText: String
    private var cipherText: String?

    required init(message: String) {
        self.clearText = message
    }

    func prepareMessage() {
        cipherText = String(clearText.reversed())
    }

    var contentToSend: String {
        return cipherText ?? ""
    }
}

protocol Channel {
    func sendMessage(message: Message)
}

class LandlineChannel: Channel {
    func sendMessage(message: Message) {
        print("Landline: \(message.contentToSend)")
    }
}

class WirelessChannel: Channel {
    func sendMessage(message: Message) {
        print("Wireless: \(message.contentToSend)")
    }
}

class CommunicatorBridge: ClearMessageChannel, SecureMessageChannel, PriorityMessageChannel {
    private var channel: Channel

    init(channel: Channel) {
        self.channel = channel
    }

    func send(message: String) {
        let message = ClearMessage(message: message)
        sendMessage(message: message)
    }

    func sendEncryptedMessage(encryptedText: String) {
        let message = EncryptedMessage(message: encryptedText)
        sendMessage(message: message)
    }

    func sendPriority(message: String) {
        sendMessage(message: PriorityMessage(message: message))
    }

    private func sendMessage(message: Message) {
        message.prepareMessage()
        channel.sendMessage(message: message)
    }

}

class SatelliteChannel: Channel {
    func sendMessage(message: Message) {
        print("Satellite: \(message.contentToSend)")
    }
}

class PriorityMessage: ClearMessage {
    override var contentToSend: String {
        return "Important: \(super.contentToSend)"
    }
}

//var bridge = CommunicatorBridge(channel: LandlineChannel())
var bridge = CommunicatorBridge(channel: WirelessChannel())

//var bridge = CommunicatorBridge(channel: SatelliteChannel())
var comms = Communicator(clearChannel: bridge, secureChannel: bridge, priorityChannel: bridge)

comms.sendClearTextMessage(message: "Hello")
comms.sendSecureMessage(message: "This is a secret")
comms.sendPriorityMessage(message: "This is priority")













