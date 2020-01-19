import UIKit
import Foundation

// MARK: - Prepare factory method pattern example

protocol RentalCar {
    var name: String { get }
    var passengers: Int { get }
    var pricePerDay: Float { get }
}

class Compact: RentalCar {
    var name = "VM Golf"
    var passengers = 3
    var pricePerDay: Float = 20
}

class Sports: RentalCar {
    var name = "Porsche Boxter"
    var passengers = 1
    var pricePerDay: Float = 100
}

class SUV: RentalCar {
    var name: String = "Cadillac Escalade"
    var passengers: Int = 8
    var pricePerDay: Float = 75
}

func selectCar(passengers: Int) -> String? {
    var car: RentalCar?
    switch passengers {
    case 0...1:
        car = Sports()
    case 2...3:
        car = Compact()
    case 4...8:
        car = SUV()
    default:
        car = nil
    }

    return car?.name
}

func calculateCarPrice(passengers: Int, days: Int) -> Float? {
    var car: RentalCar?
    switch passengers {
    case 0...1:
        car = Sports()
    case 2...3:
        car = Compact()
    case 4...8:
        car = SUV()
    default:
        car = nil
    }

    if let car = car {
        return car.pricePerDay * Float(days)
    } else {
        return nil
    }
}

let passengers = [1, 3, 5]
for p in passengers {
    print("\(p) passengers: \(String(describing: selectCar(passengers: p)))")
    print("\(p) passengers: \(String(describing: calculateCarPrice(passengers: p, days: 2)))")
}

// MARK: - Factory method pattern implementation

func createRentalCar(passengers: Int) -> RentalCar? {
    var car: RentalCar?
    switch passengers {
    case 0...1:
        car = Sports()
    case 2...3:
        car = Compact()
    case 4...8:
        car = SUV()
    default:
        car = nil
    }

    return car
}

func chooseCar(passengers: Int) -> String? {
    return createRentalCar(passengers: passengers)?.name
}

func choosePrice(passengers: Int, days: Int) -> Float?{
    let car = createRentalCar(passengers: passengers)
    if let car = car {
        return car.pricePerDay * Float(days)
    } else {
        return nil
    }
}

// Use base class

class RentalCarImplementation: RentalCar {
    var name: String
    var passengers: Int
    var pricePerDay: Float

    init(name: String, passengers: Int, price: Float) {
        self.name = name
        self.passengers = passengers
        self.pricePerDay = price
    }

    class func createRentalCar(passengers: Int) -> RentalCar? {
        var car: RentalCar?
        switch passengers {
        case 0...1:
            car = Sports()
        case 2...3:
            car = Compact()
        case 4...8:
            car = SUV()
        default:
            car = nil
        }
        return car
    }
}

class Van: RentalCarImplementation {
    private init() {
        super.init(name: "Van car", passengers: 3, price: 20)
    }
}

func baseClassChooseCar(passengers: Int) -> String? {
    return RentalCarImplementation.createRentalCar(passengers: passengers)?.name
}

func baseClassChooseCarPrice(passengers: Int, days: Int) -> Float? {
    let car = RentalCarImplementation.createRentalCar(passengers: passengers)
    if let car = car {
        return car.pricePerDay * Float(days)
    } else {
        return nil
    }
}

// MARK: - Factory method pattern in Cocoa
// NSNumber, numberwithBool
