import UIKit
import Foundation

// 專案中會有物件的實例數量必須受限
// MARK: - Prepare object pool pattern example

class Book {
    let author: String
    let title: String
    let stockNumer: Int
    var reader: String?
    var checkoutCount = 0

    init(author: String, title: String, stock: Int) {
        self.author = author
        self.title = title
        self.stockNumer = stock
    }
}

class Pool<T> {
    private var data = [T]()
    private let arrayQ = DispatchQueue(label: "arrayQ")
    private let semaphore: DispatchSemaphore?

    init(items: [T]) {
        data.reserveCapacity(data.count)
        for item in items {
            data.append(item)
        }
        semaphore = DispatchSemaphore(value: items.count)
    }

    func getFromPool() -> T {
        var result: T?
        if semaphore?.wait(timeout: .distantFuture) == .success {
            arrayQ.sync {
                result = self.data.remove(at: 0)
            }
        }

        return result!
    }

    func returnToPool(item: T) {
        arrayQ.async {
            self.data.append(item)
            self.semaphore?.signal()
        }
    }
}

final class Library {
    private var books: [Book]
    private let pool: Pool<Book>

    private init(stockLevel: Int) {
        books = [Book]()
        for count in 1...stockLevel {
            books.append(Book(author: "Dickens, Charles", title: "Hard times", stock: count))
        }

        pool = Pool<Book>(items: books)
    }

    private class var singleton: Library {
        struct SingletonWrapper {
            static let singleton = Library(stockLevel: 2)
        }
        return SingletonWrapper.singleton
    }

    class func checkoutBook(reader: String) -> Book? {
        let book = singleton.pool.getFromPool()
        book.reader = reader
        book.checkoutCount += 1
        return book
    }

    class func returnBook(book: Book) {
        book.reader = nil
        singleton.pool.returnToPool(item: book)
    }

    class func printReport() {
        for book in singleton.books {
            print("...Book#\(book.stockNumer)...")
            print("Checked out \(book.checkoutCount) times")

            if book.reader != nil {
                print("Checked out to \(String(describing: book.reader))")
            } else {
                print("In stock")
            }
        }
    }
}

print("Starting...")
for i in 1...20 {
    let book = Library.checkoutBook(reader: "reader#\(i)")
    if book != nil {
        Library.returnBook(book: book!)
    }
}

print("All blocks complete")

Library.printReport()

// MARK: - Object pool pattern in Cocoa
// UITableViewCell
