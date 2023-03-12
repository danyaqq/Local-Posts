import Foundation

final class ViewsFactory {
    static func makePostsView() -> PostsView {
        let networkClient = NetworkSevice()
        let worker = PostsWorker(networkClient: networkClient)
        let viewModel = PostsViewModel(postsWorker: worker)
        let view = PostsView(viewModel: viewModel)
        return view
    }
}
