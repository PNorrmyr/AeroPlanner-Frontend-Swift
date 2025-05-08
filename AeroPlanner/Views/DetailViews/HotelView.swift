import SwiftUI

struct HotelView: View {
    let hotels: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if hotels.isEmpty {
                Text("No hotel for this day.")
                    .foregroundColor(.gray)
            } else {
                ForEach(hotels, id: \.self) { hotel in
                    Text(hotel)
                        .font(.body)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    HotelView(hotels: ["H1", "H2"])
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
} 