import SwiftUI

struct SidebarView: View {
    var onUpload: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            HStack(spacing: 16) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                VStack(alignment: .leading) {
                    Text("User Name")
                        .font(.headline)
                    Text("Flight Crew")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            Divider()
            Button(action: onUpload) {
                HStack {
                    Image(systemName: "doc.fill.badge.plus")
                    Text("Upload PDF Schedule")
                }
                .font(.system(size: 18, weight: .medium))
                .padding(.vertical, 8)
            }
            Divider()
            NavigationLink(destination: Text("Settings")) {
                Label("Settings", systemImage: "gear")
                    .font(.system(size: 18, weight: .medium))
            }
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 24)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SidebarView(onUpload: {})
} 