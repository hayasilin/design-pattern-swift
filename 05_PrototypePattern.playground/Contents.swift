import Cocoa
import Foundation

// MARK: - Prototype pattern implementation

//struct Appointment {
//    var name: String
//    var day: String
//    var place: String
//
//    func printDetails(label: String) {
//        print("\(label) with \(name) on \(day) at \(place)")
//    }
//}
//
//var beerMeeting = Appointment(name: "Bob", day: "Mom", place: "Joe's Bar")
//var workMeeting = beerMeeting
//workMeeting.name = "Alice"
//workMeeting.day = "Fri"
//workMeeting.place = "Conference Rm 2"
//
//beerMeeting.printDetails(label: "Social")
//workMeeting.printDetails(label: "Work")

// 因為struct是value type會直接複製物件

// Copy reference type issue

//class Appointment {
//    var name: String
//    var day: String
//    var place: String
//
//    init(name: String, day: String, place: String) {
//        self.name = name
//        self.day = day
//        self.place = place
//    }
//
//    func printDetails(label: String) {
//        print("\(label) with \(name) on \(day) at \(place)")
//    }
//}
//
//var beerMeeting = Appointment(name: "Bob", day: "Mom", place: "Joe's Bar")
//var workMeeting = beerMeeting
//workMeeting.name = "Alice"
//workMeeting.day = "Fri"
//workMeeting.place = "Conference Rm 2"
//
//beerMeeting.printDetails(label: "Social")
//workMeeting.printDetails(label: "Work")

// 問題在使用class是reference type，appointment物件同時被workMeeting和beerMeeting參考

// MARK: - NSCopying implementation

//class Appointment: NSCopying {
//    var name: String
//    var day: String
//    var place: String
//
//    init(name: String, day: String, place: String) {
//        self.name = name
//        self.day = day
//        self.place = place
//    }
//
//    func printDetails(label: String) {
//        print("\(label) with \(name) on \(day) at \(place)")
//    }
//
//    func copy(with zone: NSZone? = nil) -> Any {
//        return Appointment(name: self.name, day: self.day, place: self.place)
//    }
//}
//
//var beerMeeting = Appointment(name: "Bob", day: "Mom", place: "Joe's Bar")
//var workMeeting = beerMeeting.copy() as? Appointment
//workMeeting?.name = "Alice"
//workMeeting?.day = "Fri"
//workMeeting?.place = "Conference Rm 2"
//
//beerMeeting.printDetails(label: "Social")
//workMeeting?.printDetails(label: "Work")

// NSCopying協定了copy的方法，透過呼叫原型的copy方法，來複製Appointment。
// 注意：實作NSCopying不會將Reference type變為Value type。必須呼叫copy方法來複製原型。

// MARK: - Shallow copy and deep copy

// MARK: - Shallow copy implementation

//class Location {
//    var name: String
//    var address: String
//
//    init(name: String, address: String) {
//        self.name = name
//        self.address = address
//    }
//}
//
//class Appointment: NSCopying {
//    var name: String
//    var day: String
//    var place: Location
//
//    init(name: String, day: String, place: Location) {
//        self.name = name
//        self.day = day
//        self.place = place
//    }
//
//    func printDetails(label: String) {
//        print("\(label) with \(name) on \(day) at \(place.name), \(place.address)")
//    }
//
//    func copy(with zone: NSZone? = nil) -> Any {
//        return Appointment(name: self.name, day: self.day, place: self.place)
//    }
//}
//
//var beerMeeting = Appointment(name: "Bob", day: "Mom", place: Location(name: "Joe's Bar", address: "134 Main st"))
//var workMeeting = beerMeeting.copy() as? Appointment
//workMeeting?.name = "Alice"
//workMeeting?.day = "Fri"
//workMeeting?.place.name = "Conference Rm 2"
//workMeeting?.place.address = "Company HQ"
//
//beerMeeting.printDetails(label: "Social")
//workMeeting?.printDetails(label: "Work")

// MARK: - Deep copy implementation

class Location: NSCopying {
    var name: String
    var address: String

    init(name: String, address: String) {
        self.name = name
        self.address = address
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Location(name: self.name, address: self.address)
    }
}

class Appointment: NSCopying {
    var name: String
    var day: String
    var place: Location

    init(name: String, day: String, place: Location) {
        self.name = name
        self.day = day
        self.place = place
    }

    func printDetails(label: String) {
        print("\(label) with \(name) on \(day) at \(place.name), \(place.address)")
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Appointment(name: self.name, day: self.day, place: self.place.copy() as? Location ?? Location(name: "", address: ""))
    }
}

var beerMeeting = Appointment(name: "Bob", day: "Mom", place: Location(name: "Joe's Bar", address: "134 Main st"))
var workMeeting = beerMeeting.copy() as? Appointment
workMeeting?.name = "Alice"
workMeeting?.day = "Fri"
workMeeting?.place.name = "Conference Rm 2"
workMeeting?.place.address = "Company HQ"

beerMeeting.printDetails(label: "Social")
workMeeting?.printDetails(label: "Work")

// MARK: - Copy array

class Person: NSObject, NSCopying {
    var name: String
    var country: String

    init(name: String, country: String) {
        self.name = name
        self.country = country
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return Person(name: self.name, country: self.country)
    }
}

//var people = [
//    Person(name: "Joe", country: "France"),
//    Person(name: "Bob", country: "USA")
//]
//
//var otherPeople = people
//
//people[0].country = "UK"
//print("Country: \(otherPeople[0].country)")

func deepCopy(data: [AnyObject]) -> [AnyObject] {
    return data.map { (item) -> AnyObject in
        if item is NSCopying && item is NSObject {
            return (item as! NSObject).copy() as AnyObject
        } else {
            return item
        }
    }
}

var people = [
    Person(name: "Joe", country: "France"),
    Person(name: "Bob", country: "USA")
]

var otherPeople = deepCopy(data: people) as! [Person]

people[0].country = "UK"
print("Country: \(otherPeople[0].country)")

// Prototype patter's advantage
// 避免物件過多計算造成昂貴的初始化，例如有物件運用複雜的計算來建立，但套用prototype pattern可以選擇性的以copy來複製物件
