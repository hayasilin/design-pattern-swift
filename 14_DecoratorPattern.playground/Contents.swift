import UIKit
import Foundation

class Purchase {
    private let product: String
    private let price: Float

    init(product: String, price: Float) {
        self.product = product
        self.price = price
    }

    var description: String {
        return product
    }

    var totalPrice: Float {
        return price
    }
}

class CustomerAccount {
    let customerName: String
    var purchases = [Purchase]()

    init(name: String) {
        self.customerName = name
    }

    func addPurchase(purchase: Purchase) {
        self.purchases.append(purchase)
    }

    func printAccount() {
        var total: Float = 0
        for p in purchases {
            total += p.totalPrice
            print("Purchase \(p), price: \(formatCurrencyString(number: p.totalPrice))")
        }

        print("Total due: \(formatCurrencyString(number: total))")
    }

    func formatCurrencyString(number: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        return formatter.string(from: NSNumber(value: number)) ?? ""
    }
}

//print("Nomal way")
//let account = CustomerAccount(name: "Joe")
//account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
//account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
//account.printAccount()

// ----------
// 假設我想要提供客戶一些禮品選項，但不能修改Purchase與CustomerAccount，最常見的原因是它們由第三方提供。
// 加入禮品選項的最明顯方式是建構Purchase的子類別，這樣可讓我去定義新的行為。
// 這些子類別可以運作，但並不符合我的業務需求，顧客無法混搭選項，每個子類別只能代表單一的選項，無法表示顧客想要禮物包裝與運送，只能在用另一個子類別來表示此種組合

class PurchaseWithGiftWrap: Purchase {
    override var description: String {
        return "\(super.description) + giftwrap"
    }

    override var totalPrice: Float {
        return super.totalPrice + 2
    }
}

class PurchaseWithRibbon: Purchase {
    override var description: String {
        return "\(super.description) + ribbon"
    }

    override var totalPrice: Float {
        return super.totalPrice + 1
    }
}

class PurchaseWithDelivery: Purchase {
    override var description: String {
        return "\(super.description) + delivery"
    }

    override var totalPrice: Float {
        return super.totalPrice + 5
    }
}

class PurchaseWithGiftWrapAndDelivery: Purchase {
    override var description: String {
        return "\(super.description) + giftwrap + delivery"
    }

    override var totalPrice: Float {
        return super.totalPrice + 5 + 2
    }
}

//let account = CustomerAccount(name: "Joe")
//account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
//account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
//account.addPurchase(purchase: PurchaseWithGiftWrap(product: "Sunglasses", price: 25))
//
//account.printAccount()

// 類別的數量會隨著要處理的選項增加，代表錯誤風險及維護的困難
// 舉例來說，改變選項的價格需要大量的修改工作，很容易漏掉一或多個需要更改的類別

// ----------
// Decorator pattern implementation

class BasePurchaseDecorator: Purchase {
    private let wrappedPurchase: Purchase

    init(purchase: Purchase) {
        wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }
}

class PurchaseWithGiftWrapDecorator: BasePurchaseDecorator {
    override var description: String { return "\(super.description) + giftwrap" }
    override var totalPrice: Float { return super.totalPrice + 2 }
}

class PurchaseWithRibbonDecorator: BasePurchaseDecorator {
    override var description: String { return "\(super.description) + ribbon" }
    override var totalPrice: Float { return super.totalPrice + 1 }
}

class PurchaseWithDeliveryDecorator: BasePurchaseDecorator {
    override var description: String { return "\(super.description) + delivery" }
    override var totalPrice: Float { return super.totalPrice + 5 }
}

//let account = CustomerAccount(name: "Joe")
//account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
//account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
//print("Use decorator pattern")
//account.addPurchase(purchase: PurchaseWithDeliveryDecorator(purchase: PurchaseWithGiftWrapDecorator(purchase: Purchase(product: "Sunglasses", price: 25))))
//account.printAccount()

// Decorator模式的變化

class DiscountDecorator: Purchase {
    private let wrappedPurchase: Purchase

    init(purchase: Purchase) {
        self.wrappedPurchase = purchase
        super.init(product: purchase.description, price: purchase.totalPrice)
    }

    override var description: String {
        return super.description
    }

    var discountAmount: Float {
        return 0
    }

    func countDiscounts() -> Int {
        var total = 1
        if let discounter = wrappedPurchase as? DiscountDecorator {
            total += discounter.countDiscounts()
        }
        return total
    }
}

class BlackFridayDecorator: DiscountDecorator {
    override var totalPrice: Float {
        return super.totalPrice - discountAmount
    }

    override var discountAmount: Float {
        return super.totalPrice * 0.20
    }
}

class EndOfLineDecorator: DiscountDecorator {
    override var totalPrice: Float {
        return super.totalPrice - discountAmount
    }

    override var discountAmount: Float {
        return super.totalPrice * 0.70
    }
}

//print("Decorator patter various 1")
//let account = CustomerAccount(name: "Joe")
//account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
//account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
//account.addPurchase(purchase: EndOfLineDecorator(purchase: BlackFridayDecorator(purchase: PurchaseWithDeliveryDecorator(purchase: PurchaseWithGiftWrapDecorator(purchase: Purchase(product: "Sunglasses", price: 25))))))
//
//account.printAccount()
//
//for p in account.purchases {
//    if let d = p as? DiscountDecorator {
//        print("\(p.description) has \(d.countDiscounts()) discounts")
//    } else {
//        print("\(p.description) has no discounts")
//    }
//}

// 建構整合 Decorator

class GiftOptionDecorator: Purchase {
    private let wrappedPurchase: Purchase
    private let options: [Option]

    enum Option {
        case giftwrap
        case ribbon
        case deliver
    }

    init(purchase: Purchase, options: Option...) {
        self.wrappedPurchase = purchase
        self.options = options
        super.init(product: purchase.description, price: purchase.totalPrice)
    }

    override var description: String {
        let result = wrappedPurchase.description

        for option in options {
            switch option {
            case .giftwrap:
                return "\(result) + giftwrap"
            case .ribbon:
                return "\(result) + ribbon"
            case .deliver:
                return "\(result) + delivery"
            }
        }
        return result
    }

    override var totalPrice: Float {
        var result = wrappedPurchase.totalPrice
        for option in options {
            switch option {
            case .giftwrap:
                result += 2
            case .ribbon:
                result += 1
            case .deliver:
                result += 5
            }
        }
        return result
    }
}

print("Decorator patter various 2")
let account = CustomerAccount(name: "Joe")
account.addPurchase(purchase: Purchase(product: "Red Hat", price: 10))
account.addPurchase(purchase: Purchase(product: "Scarf", price: 20))
account.addPurchase(purchase: EndOfLineDecorator(purchase: BlackFridayDecorator(purchase: GiftOptionDecorator(purchase: Purchase(product: "Sunglasses", price: 25), options: .giftwrap, .deliver))))

account.printAccount()

for p in account.purchases {
    if let d = p as? DiscountDecorator {
        print("\(p.description) has \(d.countDiscounts()) discounts")
    } else {
        print("\(p.description) has no discounts")
    }
}

// Cocoa中的decorator pattern範例
// Cocoa將物件以NSClipView包裝，然後再以NSScrollView包裝。NSScrollView顯示捲動並處理使用者互動並管理NSClipView以決定哪個部分的UI會顯示給使用者
