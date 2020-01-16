import UIKit
import Foundation

// MARK: - Prepare example

struct Donor {
    let title: String
    let firstName: String
    let familyName: String
    let lastDonation: Float

    init(title: String, first: String, family: String, last: Float) {
        self.title = title
        self.firstName = first
        self.familyName = family
        self.lastDonation = last
    }
}

//class DonorDatabase {
//    private var donors: [Donor]
//
//    init() {
//        donors = [
//            Donor(title: "Ms", first: "Anne", family: "Jones", last: 0),
//            Donor(title: "Mr", first: "Bob", family: "Smith", last: 100),
//            Donor(title: "Dr", first: "Alice", family: "Doe", last: 200),
//            Donor(title: "Prof", first: "Joe", family: "Davis", last: 320)]
//    }
//
//    func generateGalaInvitations(maxNumber: Int) -> [String] {
//        var targetDonors: [Donor] = donors.filter({ $0.lastDonation > 0})
//        targetDonors.sorted { (donor1, donor2) -> Bool in
//            donor1.lastDonation > donor2.lastDonation
//        }
//        if targetDonors.count > maxNumber {
//            targetDonors = Array(targetDonors[0..<maxNumber])
//        }
//
//        return targetDonors.map { (donor) in
//            return "Dear \(donor.title). \(donor.familyName)"
//        }
//    }
//}
//
//let donorDb = DonorDatabase()
//
//let galaInvitations = donorDb.generateGalaInvitations(maxNumber: 2)
//for invite in galaInvitations {
//    print(invite)
//}

// MARK: - Template method pattern implementation

class DonorDatabase {
    private var donors: [Donor]

    init() {
        donors = [
            Donor(title: "Ms", first: "Anne", family: "Jones", last: 0),
            Donor(title: "Mr", first: "Bob", family: "Smith", last: 100),
            Donor(title: "Dr", first: "Alice", family: "Doe", last: 200),
            Donor(title: "Prof", first: "Joe", family: "Davis", last: 320)]
    }

    func filter(donors: [Donor]) -> [Donor] {
        return donors.filter({$0.lastDonation > 0})
    }

    func generate(donors: [Donor]) -> [String] {
        return donors.map { (donor) in
            return "Dear \(donor.title). \(donor.familyName)"
        }
    }

    func generate(maxNumber: Int) -> [String] {
        var targetDonors = filter(donors: self.donors)
        targetDonors.sorted { $0.lastDonation > $1.lastDonation }
        if targetDonors.count > maxNumber {
            targetDonors = Array(targetDonors[0..<maxNumber])
        }

        return generate(donors: targetDonors)
    }
}

let donorDb = DonorDatabase()

let galaInvitations = donorDb.generate(maxNumber: 2)
for invite in galaInvitations {
    print(invite)
}

class NewDonors: DonorDatabase {
    override func filter(donors: [Donor]) -> [Donor] {
        return donors.filter({$0.lastDonation == 0})
    }

    override func generate(donors: [Donor]) -> [String] {
        return donors.map({ "Hi \($0.firstName)" })
    }
}

let newDonor = NewDonors()
for invite in newDonor.generate(maxNumber: Int.max) {
    print(invite)
}

// MARK: - Template method pattern in Cocoa
// UIViewController's viewDidLoad function
