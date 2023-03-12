import SwiftUI

@main
struct LocalPostsApp: App {
    
    // MARK: - Private properties
    @Environment(\.scenePhase) private var scenePhase
    private let persistenceController: PostsPersistenceController
    
    // MARK: - Init
    init() {
        persistenceController = .shared
    }
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ViewsFactory.makePostsView()
        }
        .onChange(of: scenePhase) { newValue in
            switch newValue {
            case .background:
                persistenceController.save()
            default:
                return
            }
        }
    }
}
