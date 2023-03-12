import SwiftUI

struct PostCell: View {
    
    // MARK: - Public properties
    let model: PostModel
    var saveAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    var shareAction: (() -> Void)?
    
    // MARK: - Private properties
    @State private var isSaved = false
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text(model.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                HStack(spacing: 8) {
                    savedView
                    menuView
                }
            }
            Divider()
            Text(model.subtitle)
                .font(.caption)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .systemBackground))
        .shadow(color: Color.primary.opacity(0.12), radius: 13, x: 0, y: 0)
        .padding(.horizontal)
        .onFirstAppear {
            isSaved = model.isSave
        }
    }
    
    // MARK: - Menu view
    private var menuView: some View {
        Menu {
            Button(isSaved ? "Delete" : "Save") {
                isSaved ? deleteAction?() : saveAction?()
                withAnimation(.easeInOut) {
                    isSaved.toggle()
                }
            }
            
            Button("Share") {
                shareAction?()
            }
        } label: {
            Image(systemName: "ellipsis")
                .foregroundColor(Color.primary)
                .frame(width: 20, height: 20)
        }
    }
    
    // MARK: - Saved view
    @ViewBuilder private var savedView: some View {
        if isSaved {
            Image(systemName: "checkmark.square.fill")
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color.white, Color.green)
                .frame(width: 14, height: 14)
                .cornerRadius(2)
        }
    }
}
