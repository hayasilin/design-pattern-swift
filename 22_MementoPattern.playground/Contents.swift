import UIKit
import Foundation

// 此模式應用於要將物件回復到早期某一狀態，若需要支援undo最近幾個操作的功能則使用第20章的Command pattern

//class Ledger {
//    var entries = [Int: LedgerEntry]()
//    var nextId = 1
//    var total: Float = 0
//
//    func addEntry(counterParty: String, amount: Float) -> LedgerCommand {
//        nextId += 1
//        let entry = LedgerEntry(id: nextId, counterParty: counterParty, amount: amount)
//        entries[entry.id] = entry
//        total += amount
//        return createUndoCommand(entry: entry)
//    }
//
//    private func createUndoCommand(entry: LedgerEntry) -> LedgerCommand {
//        return LedgerCommand(instructions: { (target) in
//            let removed = target.entries.removeValue(forKey: entry.id)
//            if removed != nil {
//                target.total -= removed!.amount
//            }
//        }, receiver: self)
//    }
//
//    func printEntries() {
//        for id in entries.keys.sorted() {
//            if let entry = entries[id] {
//                print("#\(id): \(entry.counterParty) $\(entry.amount)")
//            }
//        }
//        print("Total: $\(total)")
//        print("---")
//    }
//}

class LedgerEntry {
    let id: Int
    let counterParty: String
    let amount: Float

    init(id: Int, counterParty: String, amount: Float) {
        self.id = id
        self.counterParty = counterParty
        self.amount = amount
    }
}

class LedgerCommand {
    private let instructions: (Ledger) -> Void
    private let receiver: Ledger

    init(instructions: @escaping (Ledger) -> Void, receiver: Ledger) {
        self.instructions = instructions
        self.receiver = receiver
    }

    func execute() {
        self.instructions(self.receiver)
    }
}

//let ledger = Ledger()
//ledger.addEntry(counterParty: "Bob", amount: 100.43)
//ledger.addEntry(counterParty: "Joe", amount: 200.20)
//let undoCommand = ledger.addEntry(counterParty: "Alice", amount: 500)
//ledger.addEntry(counterParty: "Tony", amount: 20)
//
//ledger.printEntries()
//undoCommand.execute()
//ledger.printEntries()

// 以上範例使用command pattern實作undo功能，雖然可以undo個別的操作，但不能還原Ledger到最初的狀態
// 需要一個個物件去處理，因此使用Memento pattern來處理

// MARK: - Memento pattern implementation

protocol Memento {

}

protocol Originator {
    func createMemento() -> Memento
    func applyMemento(memento: Memento)
}

class LedgerMemento: Memento {
    private var entries = [LedgerEntry]()
    private let total: Float
    private let nextId: Int

    init(ledger: Ledger) {
        self.entries = Array(ledger.entries.values)
        self.total = ledger.total
        self.nextId = ledger.nextId
    }

    func apply(ledger: Ledger) {
        ledger.total = self.total
        ledger.nextId = self.nextId
        ledger.entries.removeAll(keepingCapacity: true)
        for entry in self.entries {
            ledger.entries[entry.id] = entry
        }
    }
}

class Ledger: Originator {
    var entries = [Int: LedgerEntry]()
    var nextId = 1
    var total: Float = 0

    func addEntry(counterParty: String, amount: Float) {
        nextId += 1
        let entry = LedgerEntry(id: nextId, counterParty: counterParty, amount: amount)
        entries[entry.id] = entry
        total += amount
    }

    func createMemento() -> Memento {
        return LedgerMemento(ledger: self)
    }

    func applyMemento(memento: Memento) {
        if let m = memento as? LedgerMemento {
            m.apply(ledger: self)
        }
    }

    func printEntries() {
        for id in entries.keys.sorted() {
            if let entry = entries[id] {
                print("#\(id): \(entry.counterParty) $\(entry.amount)")
            }
        }
        print("Total: $\(total)")
        print("---")
    }
}

let ledger = Ledger()
ledger.addEntry(counterParty: "Bob", amount: 100.43)
ledger.addEntry(counterParty: "Joe", amount: 200.20)

let memento = ledger.createMemento()

ledger.addEntry(counterParty: "Alice", amount: 500)
ledger.addEntry(counterParty: "Tony", amount: 20)

ledger.printEntries()

ledger.applyMemento(memento: memento)

ledger.printEntries()

// MARK: - Memento pattern in Cocoa
// NSCoding, NSCoder
// Cocoa透過NSCoding協定提供memento pattern的實作，符合此協定的originator物件與NSCoder物件共同
// 運作以產生其狀態的快照。NSCoder可做出子類別以支援不同的資料格式
