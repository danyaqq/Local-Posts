import Foundation
import CoreData

protocol PostsWorkerProtocol {
    func getRemotePosts() async throws -> [PostModel]
    func getLocalPosts() -> [PostModel]
    func savePost(_ post: PostModel)
    func deletePost(_ post: PostModel)
}

final class PostsWorker: PostsWorkerProtocol {
    
    // MARK: - Private properties
    private let persistenceController: PostsPersistenceController
    private let networkClient: NetworkClient
    
    // MARK: - Init
    init(networkClient: NetworkClient) {
        self.persistenceController = .shared
        self.networkClient = networkClient
    }
    
    // MARK: - Public methods
    func getRemotePosts() async throws -> [PostModel] {
        let posts = try await fetchRemotePosts()
        return posts.map {
            let isSave = isSavePost(with: $0.id)
            return PostModel(id: $0.id, title: $0.title, subtitle: $0.body, isSave: isSave)
        }
    }
    
    func getLocalPosts() -> [PostModel] {
        let entities = persistenceController.getEntities()
        return entities.map {
            PostModel(id: Int($0.id),
                      title: $0.title.orEmpty,
                      subtitle: $0.subtitle.orEmpty,
                      isSave: true)
        }
    }
    
    func savePost(_ post: PostModel) {
        let context = persistenceController.container.viewContext
        let postEntity = PostEntity(context: context)
        postEntity.id = Int16(post.id)
        postEntity.title = post.title
        postEntity.subtitle = post.subtitle
        persistenceController.save()
    }
    
    func deletePost(_ post: PostModel) {
        let entities = persistenceController.getEntities()
        guard let object = entities.first(where: { $0.id == post.id }) else { return }
        persistenceController.delete(object)
    }
}

// MARK: - Private methods
private extension PostsWorker {
    func fetchRemotePosts() async throws -> [PostResponse] {
        guard let request = PostRequestFactory.list.makeRequest() else {
            throw RequestError.badRequest
        }
        return try await networkClient.perform(request: request)
    }
    
    func isSavePost(with id: Int) -> Bool {
        let entities = persistenceController.getEntities()
        let filteredEntities = entities.filter { $0.id == id }
        return filteredEntities.isEmpty ? false : true
    }
}

protocol Routable {
    var navigationController: UINavigationController { get set }
    func push(_ view: some View, animated: Bool)
    func pop(animated: Bool)
    func popToRoot(animated: Bool)
    func as785349978345d()
}

