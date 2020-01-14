import UIKit
import Foundation

class TreasureMap {
    enum Treasures {
        case galleon
        case buriedGold
        case sunkenJewels
    }

    struct MapLocation {
        let gridLetter: Character
        let gridNumber: UInt
    }

    func findTreasure(type: Treasures) -> MapLocation {
        switch type {
        case .galleon:
            return MapLocation(gridLetter: "D", gridNumber: 6)
        case .buriedGold:
            return MapLocation(gridLetter: "C", gridNumber: 2)
        case .sunkenJewels:
            return MapLocation(gridLetter: "F", gridNumber: 12)
        }
    }
}

class PirateShip {
    struct ShipLocation {
        let NorthSouth: Int
        let EastWest: Int
    }

    var currentposition: ShipLocation

    init() {
        currentposition = ShipLocation(NorthSouth: 5, EastWest: 5)
    }

    func moveToLocation(location: ShipLocation, callback: (ShipLocation) -> Void) {
        self.currentposition = location
        callback(self.currentposition)
    }
}

class PirateCrew {
    enum Actions {
        case attackShip
        case digForGold
        case diveForJewels
    }

    func performAction(action: Actions, callback: (Int) -> Void) {
        var prizeValue = 0
        switch action {
        case .attackShip:
            prizeValue = 10000
        case .digForGold:
            prizeValue = 5000
        case .diveForJewels:
            prizeValue = 1000
        }
        callback(prizeValue)
    }
}

let map = TreasureMap()
let ship = PirateShip()
let crew = PirateCrew()

// 此範例有3個類別且必須一起使用才能為海賊提供收益。這些類別必須以特定順序使用，
// 從地圖取得寶藏位置之前開船沒意義，船到達定點前指派工作給船員也沒意義。這樣的問題在於協調運用這些類別來尋寶有很高的複雜性。

let treasureLocation = map.findTreasure(type: .galleon)
let sequence: [Character] = ["A", "B", "C", "D", "E", "F", "G"]
let eastWestPos = sequence.firstIndex(of: treasureLocation.gridLetter)

let shipTarget = PirateShip.ShipLocation(NorthSouth: Int(treasureLocation.gridNumber), EastWest: eastWestPos!)

ship.moveToLocation(location: shipTarget) { (location) in
    crew.performAction(action: .attackShip) { (prize) in
        print("Prize: \(prize) pieces of eight")
    }
}

// Facade pattern implementation

enum TreasureTypes {
    case ship
    case buried
    case sunken
}

class PirateFacade {
    let map = TreasureMap()
    let ship = PirateShip()
    let crew = PirateCrew()

    func getTreasure(type: TreasureTypes) -> Int? {
        var prizeAmount: Int?
        var treasureMapType: TreasureMap.Treasures
        var crewWorkType: PirateCrew.Actions

        switch type {
        case .ship:
            treasureMapType = .galleon
            crewWorkType = .attackShip
        case .buried:
            treasureMapType = .buriedGold
            crewWorkType = .digForGold
        case .sunken:
            treasureMapType = .sunkenJewels
            crewWorkType = .diveForJewels
        }

        let treasureLocation = map.findTreasure(type: treasureMapType)

        let sequence: [Character] = ["A", "B", "C", "D", "E", "F", "G"]
        let eastWestPos = sequence.firstIndex(of: treasureLocation.gridLetter)

        let shipTarget = PirateShip.ShipLocation(NorthSouth: Int(treasureLocation.gridNumber), EastWest: eastWestPos!)

        ship.moveToLocation(location: shipTarget) { (location) in
            crew.performAction(action: crewWorkType) { (prize) in
                prizeAmount = prize
            }
        }

        return prizeAmount
    }
}

let facade = PirateFacade()
let prize = facade.getTreasure(type: .ship)
if prize != nil {
    print("Prize: \(String(describing: prize)) pieces of eight")
}

// Variation - let object can use detail function inside the facade
if prize != nil {
    facade.crew.performAction(action: .diveForJewels) { (secondPrize) in
        print("Prize: \(prize! + secondPrize) pieces of eight")
    }
}

// Facade pattern in Cocoa
// UITextView

let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
textView.text = "The quick brown fox"
textView.layoutManager.showsInvisibleCharacters = true

