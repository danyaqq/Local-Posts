import SwiftUI

struct FirstAppear: ViewModifier {
    
    // MARK: - Public properties
    let action: () -> Void
    
    // MARK: - Private properties
    @State private var hasAppeared = false
    
    // MARK: - Body
    func body(content: Content) -> some View {
        // And then, track it here
        content.onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            action()
        }
    }
}
