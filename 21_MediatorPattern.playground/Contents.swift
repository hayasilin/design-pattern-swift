import UIKit
import Foundation

// MARK - Problem
struct Position {
    var distanceFromRunway: Int
    var height: Int
}

//class Airplane: Equatable {
//    static func == (lhs: Airplane, rhs: Airplane) -> Bool {
//        return lhs.name == rhs.name
//    }
//
//    var name: String
//    var currentPosition: Position
//    private var otherPlanes: [Airplane]
//
//    init(name: String, initialPos: Position) {
//        self.name = name
//        self.currentPosition = initialPos
//        self.otherPlanes = [Airplane]()
//    }
//
//    func addPlanesInArea(planes: Airplane...) {
//        for plane in planes {
//            otherPlanes.append(plane)
//        }
//    }
//
//    func otherPlaneDidLand(plane: Airplane) {
//        if let index = otherPlanes.firstIndex(of: plane) {
//            otherPlanes.remove(at: index)
//        }
//    }
//
//    func otherPlaneDidChangePosition(plane: Airplane) -> Bool {
//        return plane.currentPosition.distanceFromRunway == self.currentPosition.distanceFromRunway
//            && abs(plane.currentPosition.height - self.currentPosition.height) < 1000
//    }
//
//    func changePosition(newPosition: Position) {
//        self.currentPosition = newPosition
//        for plane in otherPlanes {
//            if plane.otherPlaneDidChangePosition(plane: self) {
//                print("\(name): Too close! Abort")
//                return
//            }
//        }
//        print("\(name) Position changed")
//    }
//
//    func land() {
//        self.currentPosition = Position(distanceFromRunway: 0, height: 0)
//        for plane in otherPlanes {
//            plane.otherPlaneDidLand(plane: self)
//        }
//        print("\(name) Landed")
//    }
//}
//
//let british = Airplane(name: "BA706", initialPos: Position(distanceFromRunway: 11, height: 21000))
//let american = Airplane(name: "AA101", initialPos: Position(distanceFromRunway: 12, height: 22000))
//
//british.addPlanesInArea(planes: american)
//american.addPlanesInArea(planes: british)
//
//british.changePosition(newPosition: Position(distanceFromRunway: 8, height: 10000))
//british.changePosition(newPosition: Position(distanceFromRunway: 2, height: 5000))
//british.changePosition(newPosition: Position(distanceFromRunway: 1, height: 1000))
//
//let cathay = Airplane(name: "CX200", initialPos: Position(distanceFromRunway: 13, height: 22000))
//british.addPlanesInArea(planes: cathay)
//american.addPlanesInArea(planes: cathay)
//cathay.addPlanesInArea(planes: british, american)
//
//british.land()
//
//cathay.changePosition(newPosition: Position(distanceFromRunway: 12, height: 22000))

// MARK: - Mediator pattern implementation

protocol Peer {
    var name: String { get }
    func otherPlaneDidChangePosition(position: Position) -> Bool
}

protocol Mediator {
    func registerPeer(peer: Peer)
    func unregisterPeer(peer: Peer)
    func changePosition(peer: Peer, pos: Position) -> Bool
}

class AirplaneMediator: Mediator {
    private var peers: [String: Peer]

    init() {
        peers = [String: Peer]()
    }

    func registerPeer(peer: Peer) {
        self.peers[peer.name] = peer
    }

    func unregisterPeer(peer: Peer) {
        self.peers.removeValue(forKey: peer.name)
    }

    func changePosition(peer: Peer, pos: Position) -> Bool {
        for storedPeer in peers.values {
            if peer.name != storedPeer.name && storedPeer.otherPlaneDidChangePosition(position: pos) {
                return true
            }
        }
        return false
    }
}

class Airplane: Peer {


    var name: String
    var currentPosition: Position
    var mediator: Mediator

    init(name: String, initialPos: Position, mediator: Mediator) {
        self.name = name
        self.currentPosition = initialPos
        self.mediator = mediator
        mediator.registerPeer(peer: self)
    }

    func otherPlaneDidChangePosition(position: Position) -> Bool {
        return position.distanceFromRunway == self.currentPosition.distanceFromRunway
        && abs(position.height - self.currentPosition.height) < 1000
    }

    func changePosition(newPosition: Position) {
        self.currentPosition = newPosition
        if mediator.changePosition(peer: self, pos: self.currentPosition) {
            print("\(name): Too close! Abort")
            return
        }
        print("\(name) Position changed")
    }

    func land() {
        self.currentPosition = Position(distanceFromRunway: 0, height: 0)
        mediator.unregisterPeer(peer: self)
        print("\(name) Landed")
    }
}

let mediator: Mediator = AirplaneMediator()

let british = Airplane(name: "BA706", initialPos: Position(distanceFromRunway: 11, height: 21000), mediator: mediator)
let american = Airplane(name: "AA101", initialPos: Position(distanceFromRunway: 12, height: 22000), mediator: mediator)

british.changePosition(newPosition: Position(distanceFromRunway: 8, height: 10000))
british.changePosition(newPosition: Position(distanceFromRunway: 2, height: 5000))
british.changePosition(newPosition: Position(distanceFromRunway: 1, height: 1000))

let cathay = Airplane(name: "CX200", initialPos: Position(distanceFromRunway: 13, height: 22000), mediator: mediator)

british.land()

cathay.changePosition(newPosition: Position(distanceFromRunway: 12, height: 22000))

// MARK: - Mediator pattern in Cocoa
// NSNotificationCenter
// NSNotificationCenter 是以訊息為基礎的mediator，該類別也是22章Observer pattern的實作
