import CoreData

final class PostsPersistenceController {
    
    // MARK: - Static properties
    static let shared = PostsPersistenceController()
    
    // MARK: - Public properties
    let container: NSPersistentContainer
    
    // MARK: - Private properties
    private lazy var fetchController = makeFetchController()
    
    // MARK: - Init
    private init() {
        container = NSPersistentContainer(name: "PostEntity")
        loadPersistentStores()
    }
    
    // MARK: - Public methods
    func getEntities() -> [PostEntity] {
        let request = PostEntity.fetchRequest()
        do {
            return try fetchController.managedObjectContext.fetch(request)
        } catch {
            assertionFailure("Error: \(error.localizedDescription)")
            return []
        }
    }
    
    func save(completion: ((Error?) -> Void)? = nil) {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
            completion?(nil)
        } catch {
            completion?(error)
        }
    }
    
    func delete(_ object: NSManagedObject, completion: ((Error?) -> Void)? = nil) {
        let context = container.viewContext
        context.delete(object)
        save(completion: completion)
    }
}

// MARK: - Private methods
private extension PostsPersistenceController {
    func loadPersistentStores() {
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func makeFetchController() -> NSFetchedResultsController<PostEntity> {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        fetchRequest.sortDescriptors = []
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: "posts-results-controller-cache"
        )
        do {
            try controller.performFetch()
        }
        catch {
            assertionFailure("Error: \(error.localizedDescription)")
        }

        return controller
    }
}
