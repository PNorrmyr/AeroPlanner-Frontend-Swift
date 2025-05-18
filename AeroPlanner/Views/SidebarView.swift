import SwiftUI

struct SidebarView: View {
    var onUpload: () -> Void
    var onCacheCleared: () -> Void
    @State private var showClearCacheAlert = false
    @State private var showClearCacheConfirmation = false
    
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
            
            NavigationLink(destination: Text("Settings")) {
                Label("Settings", systemImage: "gear")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            Button(action: { showClearCacheAlert = true }) {
                Label("Clear Cached Data", systemImage: "trash")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Button(action: onUpload) {
                HStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Import schedule")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.bottom, 32)
        }
        .padding(.top, 60)
        .padding(.horizontal, 24)
        .frame(maxWidth: 300, alignment: .leading)
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.all)
        .alert("Clean cached data", isPresented: $showClearCacheAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Confirm", role: .destructive) {
                DataPersistenceManager.shared.clearRosterData()
                onCacheCleared()
                showClearCacheConfirmation = true
            }
        } 
    }
}

#Preview {
    SidebarView(onUpload: {}, onCacheCleared: {})
}
