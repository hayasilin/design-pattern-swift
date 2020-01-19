import UIKit
import Foundation

// MARK: - Prepare builder pattern example

enum Cooked: String {
    case rare = "Rare"
    case normal = "Normal"
    case welldone = "Well Done"
}

class Burger {
    let customerNmae: String
    let veggieProduct: Bool
    let patties: Int
    let pickles: Bool
    let mayo: Bool
    let ketchup: Bool
    let lettuce: Bool
    let cook: Cooked

    init(name: String, veggie: Bool, patties: Int, pickles: Bool, mayo: Bool, ketchup: Bool, lettuce: Bool, cook: Cooked) {
        self.customerNmae = name
        self.veggieProduct = veggie
        self.patties = patties
        self.pickles = pickles
        self.mayo = mayo
        self.ketchup = ketchup
        self.lettuce = lettuce
        self.cook = cook
    }

    func printDescription() {
        print("Name: \(customerNmae)")
        print("Veggie: \(veggieProduct)")
        print("Patties: \(patties)")
        print("Pickles: \(pickles)")
        print("Mayo: \(mayo)")
        print("Ketchup: \(ketchup)")
        print("lettuce: \(lettuce)")
        print("Cook: \(cook.rawValue)")
    }
}

let order = Burger(name: "Joe", veggie: false, patties: 2, pickles: true, mayo: true, ketchup: true, lettuce: true, cook: .normal)
order.printDescription()

// MARK: - Builder pattern implementation

class BurgerBuilder {
    var veggie: Bool = false
    var patties: Int = 2
    var pickles: Bool = true
    var mayo: Bool = true
    var ketchup: Bool = true
    var lettuce: Bool = true
    var cook: Cooked = .normal

    func build(name: String) -> Burger {
        return Burger(name: name, veggie: veggie, patties: patties, pickles: pickles, mayo: mayo, ketchup: ketchup, lettuce: lettuce, cook: cook)
    }
}

print("-----")
var builder = BurgerBuilder()
builder.veggie = false
builder.mayo = false
builder.cook = .welldone
builder.patties = 3

let burger = builder.build(name: "Joe")
burger.printDescription()

// Builder pattern in Cocoa
// NSDateComponents

print("-----")
var dateBuilder = DateComponents()
dateBuilder.hour = 10
dateBuilder.day = 6
dateBuilder.month = 9
dateBuilder.year = 1940
dateBuilder.calendar = Calendar(identifier: .gregorian)

var date = dateBuilder.date
print(date!)
