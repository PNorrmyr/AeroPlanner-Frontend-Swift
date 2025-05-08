import SwiftUI

struct TimeLimitsView: View {
    let timeLimits: [String: String]
    @State private var expandedKeys: Set<String> = []
    
    private let orderedKeys = ["FT", "DT", "FDT", "FDP", "RT", "BRK", "mFDP", "xFDP", "DTwSB"]
    
    private func translatedKey(_ key: String) -> String {
        switch key {
        case "FT": return "Flight Time"
        case "DT": return "Duty Time"
        case "FDT": return "Flight Duty Time"
        case "FDP": return "Flight Duty Period"
        case "RT": return "Earliest C/I"
        case "BRK": return "Break"
        case "mFDP": return "Max Flight Duty Period"
        case "xFDP": return "Max Extended Flight Duty Period"
        case "DTwSB": return "Duty with Standby"
        default: return key
        }
    }
    
    var body: some View {
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
            ForEach(orderedKeys, id: \.self) { key in
                if let value = timeLimits[key] {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(key)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(.secondary)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                        if expandedKeys.contains(key) {
                                            expandedKeys.remove(key)
                                        } else {
                                            expandedKeys.insert(key)
                                        }
                                    }
                                }
                            Spacer(minLength: 8)
                            Text(value)
                                .font(.system(size: 20, weight: .regular))
                                .foregroundColor(.primary)
                        }
                        .frame(height: 24)
                        
                        if expandedKeys.contains(key) {
                            Text(translatedKey(key))
                                .font(.system(size: 18))
                                .foregroundColor(.secondary)
                                .padding(.leading, 4)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TimeLimitsView(timeLimits: [
        "FT": "06:25",
        "DT": "10:45",
        "FDT": "08:10",
        "FDP": "08:10",
        "RT": "19/0415",
        "BRK": "015:55",
        "mFDP": "12:30",
        "xFDP": "00:00",
        "DTwSB": "10:45"
    ])
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(radius: 2)
} 
