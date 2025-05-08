import SwiftUI

struct SubtitleView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title section
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.top)
            
            // Info text with gray background
            Text(subtitle)
                .font(.body)
                .foregroundColor(.primary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom)
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    SubtitleView(title: "Exempel Titel", subtitle: "Exempel Undertext")
}
