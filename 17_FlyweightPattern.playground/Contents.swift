import UIKit
import Foundation

class Coordinate: Hashable {
    static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
        return lhs.col == rhs.col && lhs.row == rhs.row
    }

    let col: Character
    let row: Int

    init(col: Character, row: Int) {
        self.col = col
        self.row = row
    }

    var hashValue: Int {
        return description.hashValue
    }

    var description: String {
        return "\(col)\(row)"
    }
}

class Cell {
    var coordinate: Coordinate
    var value: Int

    init(col: Character, row: Int, val: Int) {
        self.coordinate = Coordinate(col: col, row: row)
        self.value = val
    }
}

//class Spreadsheet {
//    var grid = Dictionary<Coordinate, Cell>()
//
//    init() {
//        let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
//        var stringIndex = letters.startIndex
//        let rows = 50
//
//        repeat {
//            let colLetter = letters[stringIndex]
//            stringIndex = letters.index(after: stringIndex)
//            for rowIndex in 1...rows {
//                let cell = Cell(col: colLetter, row: rowIndex, val: rowIndex)
//                grid[cell.coordinate] = cell
//            }
//        } while (stringIndex != letters.endIndex)
//    }
//
//    func setValue(coord: Coordinate, value: Int) {
//        grid[coord]?.value = value
//    }
//
//    var total: Int {
//        return grid.values.reduce(0) { (result, cell) in
//            return result + cell.value
//        }
//    }
//}

// Flyweight pattern解決建構大量相同物件，對所後用記憶體及所需時間的衝擊
// 在上面定義的Spreadsheet對矩陣中每一個位置建構Cell與Coordinate，表示每個Spreadsheet會產生大量物件
// 以下簡單的操作會產生大量的cell物件，達2600個，大部分都維持在初始化期間所設定的預設值

//let spreadSheet1 = Spreadsheet()
//spreadSheet1.setValue(coord: Coordinate(col: "A", row: 1), value: 100)
//spreadSheet1.setValue(coord: Coordinate(col: "J", row: 20), value: 200)
//print("SS1 total: \(spreadSheet1.total)")
//
//let spreadSheet2 = Spreadsheet()
//spreadSheet2.setValue(coord: Coordinate(col: "F", row: 10), value: 200)
//spreadSheet2.setValue(coord: Coordinate(col: "G", row: 23), value: 250)
//print("SS1 total: \(spreadSheet2.total)")
//
//print("Cell created: \(spreadSheet1.grid.count + spreadSheet2.grid.count)")

// Flywieght pattern implementation

protocol Flyweight {
    subscript(index: Coordinate) -> Int? { get set }
    var total: Int { get }
    var count: Int { get }
}

class FlyweightImplementation: Flyweight {
    private let extrinsicData: [Coordinate: Cell]
    private var intrinsicData: [Coordinate: Cell]

    init(extrinsic: [Coordinate: Cell]) {
        self.extrinsicData = extrinsic
        self.intrinsicData = Dictionary<Coordinate, Cell>()
    }

    subscript(index: Coordinate) -> Int? {
        get {
            if let cell = intrinsicData[index] {
                return cell.value
            } else {
                return extrinsicData[index]?.value
            }
        }
        set {
            if newValue != nil {
                intrinsicData[index] = Cell(col: index.col, row: index.row, val: newValue!)
            }
        }
    }

    var total: Int {
        return extrinsicData.reduce(0) { (total, data) in
            if let intrinsicCell = self.intrinsicData[data.key] {
                return total + intrinsicCell.value
            } else {
                return total + data.value.value
            }
        }
    }

    var count: Int {
        return intrinsicData.count
    }
}

extension Dictionary {
    init(setupFunc: () -> [(Key, Value)]) {
        self.init()
        for item in setupFunc() {
            self[item.0] = item.1
        }
    }
}

class FlyweightFactory {
    class func createFlyweight() -> Flyweight {
        return FlyweightImplementation(extrinsic: extrinsicData)
    }

    private class var extrinsicData: [Coordinate: Cell] {
        get {
            struct singletonWrapp {
                static let singletonData = Dictionary<Coordinate, Cell> {
                    var results = [(Coordinate, Cell)]()
                    let letters: String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
                    var stringIndex = letters.startIndex
                    let rows = 50

                    repeat {
                        let colLetter = letters[stringIndex]
                        stringIndex = letters.index(after: stringIndex)
                        for rowIndex in 1...rows {
                            let cell = Cell(col: colLetter, row: rowIndex, val: rowIndex)
                            results.append((cell.coordinate, cell))
                        }
                    } while (stringIndex != letters.endIndex)

                    return results
                }
            }
            return singletonWrapp.singletonData
        }
    }
}

class Spreadsheet {
    var grid: Flyweight

    init() {
        grid = FlyweightFactory.createFlyweight()
    }

    func setValue(coord: Coordinate, value: Int) {
        grid[coord] = value
    }

    var total: Int {
        return grid.total
    }
}

let spreadSheet1 = Spreadsheet()
spreadSheet1.setValue(coord: Coordinate(col: "A", row: 1), value: 100)
spreadSheet1.setValue(coord: Coordinate(col: "J", row: 20), value: 200)
print("SS1 total: \(spreadSheet1.total)")

let spreadSheet2 = Spreadsheet()
spreadSheet2.setValue(coord: Coordinate(col: "F", row: 10), value: 200)
spreadSheet2.setValue(coord: Coordinate(col: "G", row: 23), value: 250)
print("SS1 total: \(spreadSheet2.total)")

print("Cell created: \(spreadSheet1.grid.count + spreadSheet2.grid.count)")

// Flyweight pattern in Cocoa
// NSNumber

let num1 = NSNumber(value: 10)
let num2 = NSNumber(value: 10)

print("Comparision: \(num1 == num2)")
print("Identity: \(num1 === num2)")
