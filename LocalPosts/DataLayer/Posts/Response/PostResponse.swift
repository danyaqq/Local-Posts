import Foundation

struct PostResponse: Decodable {
    let id: Int
    let title: String
    let body: String
}
