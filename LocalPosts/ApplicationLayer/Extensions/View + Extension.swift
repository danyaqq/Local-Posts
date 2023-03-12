import SwiftUI

extension View {
    var rootViewController: UIViewController? {
        let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        let rootViewController = scene?
            .windows.first(where: { $0.isKeyWindow })?
            .rootViewController
        return rootViewController
    }
}

extension View {
    func onFirstAppear(_ action: @escaping (() -> Void)) -> some View {
        modifier(FirstAppear(action: action))
    }
}
