import SwiftUI

struct PostsView: View {
    
    typealias ContentDisplayType = PostsViewModel.ContentDisplayType
    typealias ScreenState = PostsViewModel.ScreenState
    
    // MARK: - Private properties
    @StateObject private var viewModel: PostsViewModel
    
    // MARK: - Init
    init(viewModel: PostsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            VStack {
                pickerView
                tabView
            }
            .navigationTitle("Posts")
        }
    }
    
    // MARK: - Picker view
    private var pickerView: some View {
        Picker("Type of content displayed", selection: $viewModel.contentDisplayType) {
            ForEach(ContentDisplayType.allCases, id: \.rawValue) { type in
                Text(type.rawValue)
                    .tag(type)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    // MARK: - Tab view
    private var tabView: some View {
        TabView(selection: $viewModel.contentDisplayType) {
            ForEach(ContentDisplayType.allCases, id: \.rawValue) { type in
                contentView(by: type)
                    .tag(type)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    // MARK: - Content view
    @ViewBuilder private func contentView(by type: ContentDisplayType) -> some View {
        let screenState = getScreenState(by: type)
        switch screenState {
        case .loading:
            loadingView
        case .success:
            successView(contentDisplayType: type)
        case .failure(let errorMessage):
            errorView(errorMessage, contentDisplayType: type)
        }
    }
    
    // MARK: - Loading view
    private var loadingView: some View {
        ProgressView()
            .tint(Color.red)
    }
    
    // MARK: - Success view
    @ViewBuilder private func successView(contentDisplayType: ContentDisplayType) -> some View {
        switch contentDisplayType {
        case .remote:
            postsListView(posts: viewModel.posts)
        case .local:
            postsListView(posts: viewModel.localPosts)
        }
    }
    
    // MARK: - Posts list view
    private func postsListView(posts: [PostModel]) -> some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(posts, id: \.id) { post in
                    PostCell(model: post,
                             saveAction: {
                        viewModel.savePost(post)
                    },
                             deleteAction: {
                        viewModel.deletePost(post)
                    },
                             shareAction: {
                        showShareSheet(with: post)
                    })
                }
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Error view
    private func errorView(_ errorMessage: String,
                           contentDisplayType: ContentDisplayType) -> some View {
        VStack(spacing: 0) {
            Text("Error")
                .font(.title2)
                .fontWeight(.semibold)
            Text(errorMessage)
                .font(.caption)
                .padding(.top, 8)
            Button {
                switch contentDisplayType {
                case .remote:
                    viewModel.getRemotePosts()
                case .local:
                    viewModel.getLocalPosts()
                }
            } label: {
                Text("Update")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .foregroundColor(Color.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color(uiColor: .systemBackground))
                    .shadow(color: Color.primary.opacity(0.12), radius: 13, x: 0, y: 0)
                    .padding(.horizontal)
            }
            .padding(.top, 20)
        }
    }
}

// MARK: - Private methods
private extension PostsView {
    func showShareSheet(with post: PostModel) {
        let activityController = UIActivityViewController(
            activityItems: [post.title],
            applicationActivities: nil
        )
        rootViewController?.present(
            activityController,
            animated: true,
            completion: nil
        )
    }
    
    func getScreenState(by type: ContentDisplayType) -> ScreenState {
        switch type {
        case .local:
            return viewModel.localScreenState
        case .remote:
            return viewModel.remoteScreenState
        }
    }
}


