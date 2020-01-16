import UIKit
import Foundation

// MARK: - Prepare example

//class Circle {
//    let radius: Float
//
//    init(radius: Float) {
//        self.radius = radius
//    }
//}
//
//class Square {
//    let length: Float
//
//    init(length: Float) {
//        self.length = length
//    }
//}
//
//class Rectangle {
//    let xLen: Float
//    let yLen: Float
//
//    init(x: Float, y: Float) {
//        self.xLen = x
//        self.yLen = y
//    }
//}
//
//class ShapeCollection {
//    let shapes: [Any]
//
//    init() {
//        shapes = [Circle(radius: 2.5), Square(length: 4), Rectangle(x: 10, y: 2)]
//    }
//
//    func calculateAreas() -> Float {
//        return shapes.reduce(0) { (total, shape) in
//            if let circle = shape as? Circle {
//                print("Found circle")
//                return total + (3.14 * powf(circle.radius, 2))
//            } else if let square = shape as? Square {
//                print("Found square")
//                return total + (powf(square.length, 2))
//            } else if let rect = shape as? Rectangle {
//                print("Found rectangle")
//                return total + (rect.xLen + rect.yLen)
//            } else {
//                return total
//            }
//        }
//    }
//}
//
//let shapes = ShapeCollection()
//let area = shapes.calculateAreas()
//print("Area: \(area)")

// MARK: - Visitor pattern implementation

protocol Visitor {
    func visit(shape: Circle)
    func visit(shape: Square)
    func visit(shape: Rectangle)
}

protocol Shape {
    func accept(visitor: Visitor)
}

class Circle: Shape {
    let radius: Float

    init(radius: Float) {
        self.radius = radius
    }

    func accept(visitor: Visitor) {
        visitor.visit(shape: self)
    }
}

class Square: Shape {
    let length: Float

    init(length: Float) {
        self.length = length
    }

    func accept(visitor: Visitor) {
        visitor.visit(shape: self)
    }
}

class Rectangle: Shape {
    let xLen: Float
    let yLen: Float

    init(x: Float, y: Float) {
        self.xLen = x
        self.yLen = y
    }

    func accept(visitor: Visitor) {
        visitor.visit(shape: self)
    }
}

class ShapeCollection {
    let shapes: [Shape]

    init() {
        shapes = [Circle(radius: 2.5), Square(length: 4), Rectangle(x: 10, y: 2)]
    }

    func accept(visitor: Visitor) {
        for shape in shapes {
            shape.accept(visitor: visitor)
        }
    }
}

class AreaVisitor: Visitor {
    var totalArea: Float = 0

    func visit(shape: Circle) {
        totalArea += (3.14 * powf(shape.radius, 2))
    }

    func visit(shape: Square) {
        totalArea += powf(shape.length, 2)
    }

    func visit(shape: Rectangle) {
        totalArea += (shape.xLen * shape.yLen)
    }
}

class EdgesVisitor: Visitor {
    var totalEdges = 0

    func visit(shape: Circle) {
        totalEdges += 1
    }

    func visit(shape: Square) {
        totalEdges += 4
    }

    func visit(shape: Rectangle) {
        totalEdges += 4
    }
}

let shapes = ShapeCollection()
let areaVisitor = AreaVisitor()
shapes.accept(visitor: areaVisitor)
print("Area: \(areaVisitor.totalArea)")

let edgeVisitor = EdgesVisitor()
shapes.accept(visitor: edgeVisitor)
print("Edges: \(edgeVisitor.totalEdges)")

// MARK: - Visitor pattern in Cocoa
// There are no visitor pattern implementation in Cocoa
