import SwiftUI

struct CrewView: View {
    let crew: Crew
    
    private func formatCrewMember(_ member: String) -> (name: String, position: String) {
        let components = member.split(separator: " ", maxSplits: 1)
        if components.count == 2 {
            return (String(components[1]), String(components[0]))
        }
        return (member, "")
    }
    
    private func createGridLayout(for count: Int) -> [GridItem] {
        let columns = 2
        return Array(repeating: GridItem(.flexible(), spacing: 16), count: columns)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !crew.cockpit.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Cockpit")
                        .font(.system(size: 25))
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: createGridLayout(for: crew.cockpit.count), spacing: 16) {
                        ForEach(crew.cockpit, id: \.self) { member in
                            let formatted = formatCrewMember(member)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(formatted.name)
                                    .font(.system(size: 20))
                                    .fontDesign(.rounded)
                                    .fontWeight(.medium)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(formatted.position)
                                    .font(.system(size: 16))
                                    .fontDesign(.rounded)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 44)
                        }
                    }
                }
            }
            if !crew.cabin.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Cabin")
                        .font(.system(size: 25))
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Divider()
                    
                    LazyVGrid(columns: createGridLayout(for: crew.cabin.count), spacing: 16) {
                        ForEach(crew.cabin, id: \.self) { member in
                            let formatted = formatCrewMember(member)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(formatted.name)
                                    .font(.system(size: 20))
                                    .fontDesign(.rounded)
                                    .fontWeight(.medium)
                                    .fixedSize(horizontal: false, vertical: true)
                                Text(formatted.position)
                                    .font(.system(size: 16))
                                    .fontDesign(.rounded)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(minHeight: 44)
                        }
                    }
                }
            }
            
            if crew.cockpit.isEmpty && crew.cabin.isEmpty {
                Text("No crew information available")
                    .font(.body)
                    .fontDesign(.rounded)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CrewView(crew: Crew(
        cockpit: ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"],
        cabin: ["10355 Mosfjeld Morten", "103830 Duncan Fiona Catherine", "10355 Mosfjeld Morten", "10355 Mosfjeld Morten", "10355 Mosfjeld Morten"],
        flight_num: "DY537"
    ))
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(radius: 2)
} 
