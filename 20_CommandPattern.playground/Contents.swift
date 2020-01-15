import UIKit
import Foundation

//class Calculator {
//    private(set) var total = 0
//
//    func add(amount: Int) {
//        total += amount
//    }
//
//    func subtract(amount: Int) {
//        total -= amount
//    }
//
//    func multiply(amount: Int) {
//        total = total * amount
//    }
//
//    func divide(amount: Int) {
//        total = total / amount
//    }
//}
//
//let calculator = Calculator()
//calculator.add(amount: 10)
//calculator.multiply(amount: 4)
//calculator.subtract(amount: 2)
//
//print("Total: \(calculator.total)")

// MARK: - Command pattern Implementation

protocol Command {
    func execute()
}

class GenericCommand<T>: Command {
    private var receiver: T
    private var instructions: (T) -> Void

    init(receiver: T, instructions: @escaping (T) -> Void) {
        self.receiver = receiver
        self.instructions = instructions
    }

    func execute() {
        instructions(receiver)
    }

    class func createCommand(receiver: T, instuctions: @escaping (T) -> Void) -> Command {
        return GenericCommand(receiver: receiver, instructions: instuctions)
    }
}

class Calculator {
    private(set) var total = 0
    private var history = [Command]()

    func add(amount: Int) {
        addUndoCommand(method: Calculator.subtract, amount: amount)
        total += amount
    }

    func subtract(amount: Int) {
        addUndoCommand(method: Calculator.add, amount: amount)
        total -= amount
    }

    func multiply(amount: Int) {
        addUndoCommand(method: Calculator.divide, amount: amount)
        total = total * amount
    }

    func divide(amount: Int) {
        addUndoCommand(method: Calculator.multiply, amount: amount)
        total = total / amount
    }

    private func addUndoCommand(method: @escaping (Calculator) -> (Int) -> Void, amount: Int) {
        self.history.append(GenericCommand<Calculator>.createCommand(receiver: self, instuctions: { (calc) in
            method(calc)(amount)
        }))
    }

    func undo() {
        if self.history.count > 0 {
            self.history.removeLast().execute()
            self.history.removeLast()
        }
    }
}

let calculator = Calculator()
calculator.add(amount: 10)
calculator.multiply(amount: 4)
calculator.subtract(amount: 2)

print("Total: \(calculator.total)")

for _ in 0..<3 {
    calculator.undo()
    print("Undo called. Total: \(calculator.total)")
}

// MARK: - Command pattern in Cocoa
// NSInvocation
