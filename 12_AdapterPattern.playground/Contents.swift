import UIKit
import Foundation

struct Employee {
    var name: String
    var title: String
}

protocol EmployeeDataSource {
    var employees: [Employee] { get }
    func searchByName(name: String) -> [Employee]
    func searchByTitle(title: String) -> [Employee]
}

class DataSourceBase: EmployeeDataSource {
    var employees: [Employee] = [Employee]()

    func searchByName(name: String) -> [Employee] {
        return search({ e -> Bool in
            return e.name.contains(name)
        })
    }

    func searchByTitle(title: String) -> [Employee] {
        return search({ e -> Bool in
            return e.title.contains(title)
        })
    }

    private func search(_ selector: ((Employee) -> Bool)) -> [Employee] {
        var results = [Employee]()
        for e in employees {
            if selector(e) {
                results.append(e)
            }
        }
        return results
    }
}

class SalesDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Alice", title: "VP of Sales"))
        employees.append(Employee(name: "Bob", title: "Account Exec"))
    }
}

class DevelopmentDataSource: DataSourceBase {
    override init() {
        super.init()
        employees.append(Employee(name: "Joe", title: "VP of Development"))
        employees.append(Employee(name: "Pepe", title: "Developer"))
    }
}

class SearchTool {
    enum SearchType {
        case name
        case title
    }

    private let sources: [EmployeeDataSource]

    init(dataSources: [EmployeeDataSource]) {
        self.sources = dataSources
    }

    var employees: [Employee] {
        var results = [Employee]()
        for source in sources {
            results += source.employees
        }
        return results
    }

    func search(text: String, type: SearchType) -> [Employee] {
        var results = [Employee]()
        for source in sources {
            results += type == SearchType.name ?
                source.searchByName(name: text)
                : source.searchByTitle(title: text)
        }
        return results
    }
}

//let search = SearchTool(dataSources: [SalesDataSource(), DevelopmentDataSource()])
//print("--List--")
//for e in search.employees {
//    print("Name: \(e.name)")
//}
//print("--Search--")
//for e in search.search(text: "VP", type: SearchTool.SearchType.title) {
//    print("Name: \(e.name), Title: \(e.title)")
//}

class NewCoStaffMember {
    private var name: String
    private var role: String

    init(name: String, role: String) {
        self.name = name
        self.role = role
    }

    func getName() -> String {
        return name
    }

    func getJob() -> String {
        return role
    }
}

class NewCoDirectory {
    private var staff: [String: NewCoStaffMember]

    init() {
        staff = ["Hans": NewCoStaffMember(name: "Hans", role: "Corp Counsel"),
                 "Greta": NewCoStaffMember(name: "Greta", role: "VP, Legal")]
    }

    func getStaff() -> [String: NewCoStaffMember] {
        return staff
    }
}

extension NewCoDirectory: EmployeeDataSource {
    var employees: [Employee] {
        getStaff().values.map { (sv) -> Employee in
            return Employee(name: sv.getName(), title: sv.getJob())
        }
    }

    func searchByName(name: String) -> [Employee] {
        return createEmployees { (sv) -> Bool in
            return sv.getName().contains(name)
        }
    }

    func searchByTitle(title: String) -> [Employee] {
        return createEmployees { (sv) -> Bool in
            return sv.getJob().contains(title)
        }
    }

    private func createEmployees(filter filterClosure: ((NewCoStaffMember) -> Bool)) -> [Employee] {
        getStaff().values.map { (sv) -> Employee in
            return Employee(name: sv.getName(), title: sv.getJob())
        }
    }
}

let search = SearchTool(dataSources: [SalesDataSource(), DevelopmentDataSource(), NewCoDirectory()])
print("--List--")
for e in search.employees {
    print("Name: \(e.name)")
}
print("--Search--")
for e in search.search(text: "VP", type: SearchTool.SearchType.title) {
    print("Name: \(e.name), Title: \(e.title)")
}

// Two ways adapter
protocol shapeDrawer {
    func drawShape()
}

class DrawingApp {
    let drawer: shapeDrawer
    var cornerRadius: Int = 0

    init(drawer: shapeDrawer) {
        self.drawer = drawer
    }

    func makePicture() {
        drawer.drawShape()
    }
}

protocol AppSettings {
    var sketchRoundedShapes: Bool { get }
}

class SketchComponent {
    private let settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }

    func sketchShape() {
        if settings.sketchRoundedShapes {
            print("Sketch Circle")
        } else {
            print("Sketch Square")
        }
    }
}

class TowWayAdapter: shapeDrawer, AppSettings {
    var app: DrawingApp?
    var component: SketchComponent?

    func drawShape() {
        component?.sketchShape()
    }

    var sketchRoundedShapes: Bool {
        return app?.cornerRadius ?? 0 > 0
    }
}

let adapter = TowWayAdapter()
let component = SketchComponent(settings: adapter)
let app = DrawingApp(drawer: adapter)

adapter.app = app
adapter.component = component

app.makePicture()
