import Foundation

extension NetworkSevice {
    enum NetworkError: Error {
        case invalidStatusCode(_ statusCode: Int)
        case decoding(_ error: Error)
    }
}
