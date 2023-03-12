import Foundation

protocol NetworkClient {
    func perform<T: Decodable>(request: URLRequest) async throws -> T
}
