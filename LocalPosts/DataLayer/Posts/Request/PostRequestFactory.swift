import Foundation

enum PostRequestFactory {
    case list
    case item(newsId: Int)

    // MARK: - Private properties
    private var method: String {
        switch self {
        case .list,
             .item:
            return "GET"
        }
    }

    private var path: String {
        switch self {
        case .list:
            return "/posts"
        case let .item(postId):
            return "/posts/\(postId)"
        }
    }

    // MARK: - Public methods
    func makeRequest() -> URLRequest? {
        guard let url = URL(string: Constants.serverURL + path) else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.timeoutInterval = 10
        return request
    }
}
