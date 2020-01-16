import UIKit
import Foundation

// MARK: - Prepare example
enum Algourithm {
    case add
    case multiply
}

//class Sequence {
//    private var numbers: [Int]
//
//    init(numbers: Int...) {
//        self.numbers = numbers
//    }
//
//    func addNumber(value: Int) {
//        self.numbers.append(value)
//    }
//
//    func compute(algorithm: Algourithm) -> Int {
//        switch algorithm {
//        case .add:
//            return numbers.reduce(0, { $0 + $1 })
//        case .multiply:
//            return numbers.reduce(1, { $0 * $1 })
//        }
//    }
//}
//
//let sequence = Sequence(numbers: 1, 2, 3, 4)
//sequence.addNumber(value: 10)
//sequence.addNumber(value: 20)
//
//let sum = sequence.compute(algorithm: .add)
//print("Sum: \(sum)")
//let multiply = sequence.compute(algorithm: .multiply)
//print("Multiply: \(multiply)")

// MARK: - Strategy pattern implementation

protocol Strategy {
    func execute(values: [Int]) -> Int
}

class SumStrategy: Strategy {
    func execute(values: [Int]) -> Int {
        return values.reduce(0, { $0 + $1 })
    }
}

class MultiplyStrategy: Strategy {
    func execute(values: [Int]) -> Int {
        return values.reduce(1, { $0 * $1 })
    }
}

final class Sequence {
    private var numbers: [Int]

    init(numbers: Int...) {
        self.numbers = numbers
    }

    func addNumber(value: Int) {
        self.numbers.append(value)
    }

    func compute(strategy: Strategy) -> Int {
        strategy.execute(values: self.numbers)
    }
}

let sequence = Sequence(numbers: 1, 2, 3, 4)
sequence.addNumber(value: 10)
sequence.addNumber(value: 20)

let sumStrategy = SumStrategy()
let multiplyStrategy = MultiplyStrategy()

let sum = sequence.compute(strategy: sumStrategy)
print("Sum: \(sum)")
let multiply = sequence.compute(strategy: multiplyStrategy)
print("Multiply: \(multiply)")

// MARK: - Strategy pattern in Cocoa
// UITableView, UITableViewDataSource

class DataSourceStrategy: NSObject, UITableViewDataSource {
    let data: [String]

    init(data: [String]) {
        self.data = data
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

let dataSource = DataSourceStrategy(data: ["London", "New York", "Paris", "Rome"])
let table = UITableView(frame: CGRect(x: 0, y: 0, width: 400, height: 200))
table.dataSource = dataSource
table.reloadData()
