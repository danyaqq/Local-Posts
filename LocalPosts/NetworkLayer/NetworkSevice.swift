import Foundation

final class NetworkSevice: NetworkClient {
    
    // MARK: - Private properties
    private let decoder = JSONDecoder()
    private let urlSession = URLSession.shared
    
    // MARK: - Public methods
    func perform<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode) {
            throw(NetworkError.invalidStatusCode(response.statusCode))
        }
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw (NetworkError.decoding(error))
        }
    }
}
