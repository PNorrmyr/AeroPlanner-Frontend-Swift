import SwiftUI

struct AdditionalInfoView: View {
    let infoItems: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if infoItems.isEmpty {
                Text("No additional information available")
                    .foregroundColor(.gray)
            } else {
                ForEach(infoItems, id: \.self) { info in
                    Text(info)
                        .font(.body)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    AdditionalInfoView(infoItems: [
        "To c/m:, Autorized by, flight OPS, to operate as, Picus in May, 2025 by CP, Vikse Lien"
    ])
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(radius: 2)
} 