import Foundation

final class PostsViewModel: ObservableObject {
    
    // MARK: - Public propertis
    @Published var posts = [PostModel]()
    @Published var localPosts = [PostModel]()
    @Published var remoteScreenState: ScreenState = .loading
    @Published var localScreenState: ScreenState = .loading
    @Published var contentDisplayType: ContentDisplayType = .remote
    
    // MARK: - Private properties
    private let postsWorker: PostsWorkerProtocol
    
    // MARK: - Init
    init(postsWorker: PostsWorkerProtocol) {
        self.postsWorker = postsWorker
        getRemotePosts()
        getLocalPosts()
    }
    
    // MARK: - Public methods
    func getRemotePosts() {
        Task {
            await MainActor.run {
                self.remoteScreenState = .loading
            }
            
            do {
                let posts = try await postsWorker.getRemotePosts()
                await MainActor.run {
                    self.posts = posts
                    self.remoteScreenState = .success
                }
            } catch let error {
                await MainActor.run {
                    self.remoteScreenState = .failure(errorMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func getLocalPosts() {
        localScreenState = .loading
        let localPosts = postsWorker.getLocalPosts()
        self.localPosts = localPosts
        guard !localPosts.isEmpty else {
            localScreenState = .failure(errorMessage: "Uploaded content is missing")
            return
        }
        localScreenState = .success
    }
    
    func savePost(_ post: PostModel) {
        posts.enumerated().forEach { index, item in
            guard post.id == item.id else { return }
            posts[index].isSave = true
        }
        postsWorker.savePost(post)
        getLocalPosts()
    }
    
    func deletePost(_ post: PostModel) {
        posts.enumerated().forEach { index, item in
            guard post.id == item.id else { return }
            posts[index].isSave = false
        }
        postsWorker.deletePost(post)
        getLocalPosts()
    }
}

// MARK: - ScreenState
extension PostsViewModel {
    enum ScreenState {
        case loading
        case success
        case failure(errorMessage: String)
    }
}

// MARK: - ContentDisplayType
extension PostsViewModel {
    enum ContentDisplayType: String, CaseIterable {
        case remote
        case local
    }
}
