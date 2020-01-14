import UIKit
import Foundation

//func getHeader(header: String) {
//    let url = URL(string: "http://apress.com")
//    let request = URLRequest(url: url!)
//    URLSession.shared.dataTask(with: request) { (data, response, error) in
//        if let httpResponse = response as? HTTPURLResponse {
//            if let headerValue = httpResponse.allHeaderFields[header] as? String {
//                print("\(header): \(headerValue)")
//            }
//        }
//    }.resume()
//}
//
//let headers = ["Content-Length", "Content-Encoding"]
//for header in headers {
//    getHeader(header: header)
//}

// Proxy pattern implementation

protocol HttpHeaderRequest {
    func getHeader(urlString: String, header: String) -> String?
}

class HttpHeaderRequestProxy: HttpHeaderRequest {
    func getHeader(urlString: String, header: String) -> String? {
        var headerValue: String?

        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                headerValue = httpResponse.allHeaderFields[header] as? String
            }
        }.resume()

        return headerValue
    }
}

let url = "http://www.apress.com"
let headers = ["Content-Length", "Content-Encoding"]
let proxy = HttpHeaderRequestProxy()

for header in headers {
    if let val = proxy.getHeader(urlString: url, header: header) {
        print("\(header): \(val)")
    }
}

// Proxy pattern in Cocoa
// NSProxy
