import UIKit
import Foundation

protocol Floorplan {
    var seats: Int { get }
    var enginePosition: EngineOption { get }
}

enum EngineOption: String {
    case front = "Front"
    case mid = "Mid"
}

class ShortFloorplan: Floorplan {
    var seats = 2
    var enginePosition: EngineOption = .mid
}

class StandardFloorplan: Floorplan {
    var seats = 4
    var enginePosition: EngineOption = .front
}

class LongFloorplan: Floorplan {
    var seats: Int = 8
    var enginePosition: EngineOption = .front
}

protocol Suspension {
    var suspensionType: SuspensionOption { get }
}

enum SuspensionOption: String {
    case standard = "Standard"
    case sports = "Firm"
    case soft = "Soft"
}

class RoadSuspension: Suspension {
    var suspensionType: SuspensionOption = .standard
}

class OffRoadSuspension: Suspension {
    var suspensionType: SuspensionOption = .soft
}

class RaceSuspension: Suspension {
    var suspensionType: SuspensionOption = .sports
}

protocol Drivetrain {
    var driveType: DriveOption { get }
}

enum DriveOption: String {
    case front = "Front"
    case rear = "Rear"
    case all = "4WD"
}

class FrontWheelDrive: Drivetrain {
    var driveType: DriveOption = .front
}

class RearWheelDrive: Drivetrain {
    var driveType: DriveOption = .rear
}

class AllWheelDrive: Drivetrain {
    var driveType: DriveOption = .all
}

enum Cars: String {
    case compact = "VW Golf"
    case sports = "Porsche Boxter"
    case suv = "Cadillac Escalade"
}

struct Car {
    var carType: Cars
    var floor: Floorplan
    var suspension: Suspension
    var drive: Drivetrain

    func printDetails() {
        print("Car type: \(carType.rawValue)")
        print("Seats: \(floor.seats)")
        print("Engine: \(floor.enginePosition.rawValue)")
        print("Suspension: \(suspension.suspensionType.rawValue)")
        print("Drive: \(drive.driveType.rawValue)")
    }
}

var car = Car(carType: .sports, floor: ShortFloorplan(), suspension: RaceSuspension(), drive: RearWheelDrive())
car.printDetails()

// MARK: - Abstract factory implementation

class CarAbstractFactory {
    func createFloorplan() -> Floorplan {
        fatalError("Not implemented")
    }

    func createSuspension() -> Suspension {
        fatalError("Not implemented")
    }

    func createDriveTrain() -> Drivetrain {
        fatalError("Not implemented")
    }

    final class func getFactory(car: Cars) -> CarAbstractFactory {
        var factory: CarAbstractFactory?
        switch car {
        case .compact:
            factory = CompactCarFactory()
        case .sports:
            factory = SportsCarFactory()
        case .suv:
            factory = SUVCarFactory()
        }

        return factory!
    }
}

// Concrete factory
class CompactCarFactory: CarAbstractFactory {
    override func createFloorplan() -> Floorplan {
        return StandardFloorplan()
    }

    override func createSuspension() -> Suspension {
        return RoadSuspension()
    }

    override func createDriveTrain() -> Drivetrain {
        return FrontWheelDrive()
    }
}

class SportsCarFactory: CarAbstractFactory {
    override func createFloorplan() -> Floorplan {
        return ShortFloorplan()
    }

    override func createSuspension() -> Suspension {
        return RaceSuspension()
    }

    override func createDriveTrain() -> Drivetrain {
        return RearWheelDrive()
    }
}

class SUVCarFactory: CarAbstractFactory {
    override func createFloorplan() -> Floorplan {
        return LongFloorplan()
    }

    override func createSuspension() -> Suspension {
        return OffRoadSuspension()
    }

    override func createDriveTrain() -> Drivetrain {
        return AllWheelDrive()
    }
}

print("------")

let factory = CarAbstractFactory.getFactory(car: .sports)
car.printDetails()

// MARK: - Variation

struct VariationCar {
    var carType: Cars
    var floor: Floorplan
    var suspension: Suspension
    var drive: Drivetrain

    init(carType: Cars) {
        let concreteFactory = CarAbstractFactory.getFactory(car: carType)
        self.floor = concreteFactory.createFloorplan()
        self.suspension = concreteFactory.createSuspension()
        self.drive = concreteFactory.createDriveTrain()
        self.carType = carType
    }

    func printDetails() {
        print("Car type: \(carType.rawValue)")
        print("Seats: \(floor.seats)")
        print("Engine: \(floor.enginePosition.rawValue)")
        print("Suspension: \(suspension.suspensionType.rawValue)")
        print("Drive: \(drive.driveType.rawValue)")
    }
}

print("-----")
let variationCar = VariationCar(carType: .sports)
variationCar.printDetails()
