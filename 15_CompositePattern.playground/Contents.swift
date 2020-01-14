import UIKit
import Foundation

//class Part {
//    let name: String
//    let price: Float
//
//    init(name: String, price: Float) {
//        self.name = name
//        self.price = price
//    }
//}
//
//class CompositePart {
//    let name: String
//    let parts: [Part]
//
//    init(name: String, parts: Part...) {
//        self.name = name
//        self.parts = parts
//    }
//}

//class CustomerOrder {
//    let customer: String
//    let parts: [Part]
//    let compositeParts: [CompositePart]
//
//    init(customer: String, parts: [Part], composites: [CompositePart]) {
//        self.customer = customer
//        self.parts = parts
//        self.compositeParts = composites
//    }
//
//    var totalPrice: Float {
        // Normal way
//        let partsTotal = parts.reduce(0) { (result: Float, part: Part) -> Float in
//            result + part.price
//        }
//
//        let compositePartsTotal = compositeParts.reduce(0) { (result: Float, compositePart: CompositePart) -> Float in
//            return result + compositePart.parts.reduce(0) { (result: Float, part: Part) -> Float in
//                result + part.price
//            }
//        }
//
//        return partsTotal + compositePartsTotal

        // More cleaner way
//        let partReducer = { (subtotal: Float, part: Part) -> Float in
//            return subtotal + part.price
//        }
//
//        let partsTotal = parts.reduce(0, partReducer)
//
//        return compositeParts.reduce(partsTotal) { (result, compositePart) -> Float in
//            return compositePart.parts.reduce(result, partReducer)
//        }
//    }
//
//    func printDetails() {
//        print("Order for \(customer): Cost: \(formatCurrencyString(number: totalPrice))")
//    }
//
//    func formatCurrencyString(number: Float) -> String {
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        return formatter.string(from: NSNumber(value: number)) ?? ""
//    }
//}
//
//let doorWindow = CompositePart(name: "DoorWindow", parts: Part(name: "Window", price: 100.50),
//Part(name: "Window Switch", price: 12))
//
//let door = CompositePart(name: "Door",
//                         parts: Part(name: "Window", price: 100.5), Part(name: "Door Loom", price: 80), Part(name: "Window Switch", price: 12), Part(name: "Door Handles", price: 43.40))
//
//let hood = Part(name: "Hood", price: 320)
//let order = CustomerOrder(customer: "Bob", parts: [hood], composites: [door, doorWindow])
//order.printDetails()

// ----------
// Composite pattern implementation

protocol CarPart {
    var name: String { get }
    var price: Float { get }
}

class Part: CarPart {
    let name: String
    let price: Float

    init(name: String, price: Float) {
        self.name = name
        self.price = price
    }
}

class CompositePart: CarPart {
    let name: String
    let parts: [CarPart]

    init(name: String, parts: CarPart...) {
        self.name = name
        self.parts = parts
    }

    var price: Float {
        return parts.reduce(0) { (result, carPart) -> Float in
            return result + carPart.price
        }
    }
}

class CustomerOrder {
    let customer: String
    let parts: [CarPart]

    init(customer: String, parts: [CarPart]) {
        self.customer = customer
        self.parts = parts
    }

    var totalPrice: Float {
        return parts.reduce(0) { (result, carPart) -> Float in
            return result + carPart.price
        }
    }

    func printDetails() {
        print("Order for \(customer): Cost: \(formatCurrencyString(number: totalPrice))")
    }

    func formatCurrencyString(number: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

let doorWindow = CompositePart(name: "DoorWindow", parts: Part(name: "Window", price: 100.50),
Part(name: "Window Switch", price: 12))

let door = CompositePart(name: "Door",
                         parts: doorWindow, Part(name: "Door Loom", price: 80), Part(name: "Door Handles", price: 43.40))

let hood = Part(name: "Hood", price: 320)
let order = CustomerOrder(customer: "Bob", parts: [hood, door, doorWindow])
order.printDetails()

/// Cocoa 中最重要的composite pattern是UIView類別。在view階層中的個別view物件可以是leaf節點(例如label)或帶有一群view的composite(例如table view controller)
