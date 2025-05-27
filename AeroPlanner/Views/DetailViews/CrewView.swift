import SwiftUI

struct CrewView: View {
    let crew: Crew
    let crew_ground_event: [String]
    
    private func formatCrewMember(_ member: String) -> (name: String, position: String) {
        let components = member.split(separator: " ", maxSplits: 1)
        if components.count == 2 {
            return (String(components[1]), String(components[0]))
        }
        return (member, "")
    }
    
    private var gridLayout: [GridItem] {
        [
            GridItem(.adaptive(minimum: 150, maximum: .infinity), spacing: 16)
        ]
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if !crew.cockpit.isEmpty || !crew.cabin.isEmpty {
                // Flight Crew Section
                if !crew.cockpit.isEmpty {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cockpit")
                            .font(.system(size: 25))
                            .fontDesign(.rounded)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Divider()
                        
                        LazyVGrid(columns: gridLayout, alignment: .leading, spacing: 16) {
                            ForEach(Array(crew.cockpit.enumerated()), id: \.offset) { _, member in
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
                        
                        LazyVGrid(columns: gridLayout, alignment: .leading, spacing: 16) {
                            ForEach(Array(crew.cabin.enumerated()), id: \.offset) { _, member in
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
            } else if !crew_ground_event.isEmpty {
                // Ground Event Crew Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ground Event Crew")
                        .font(.system(size: 25))
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    
                    LazyVGrid(columns: gridLayout, alignment: .leading, spacing: 16) {
                        ForEach(Array(crew_ground_event.enumerated()), id: \.offset) { _, member in
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
            } else {
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
    Group {
        // Preview with flight crew
        CrewView(
            crew: Crew(
                cockpit: ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip","16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"],
                cabin: [
                    "10355 Mosfjeld Morten",
                    "103830 Duncan Fiona Catherine",
                    "105943 Szwagrzak Katarzyna",
                    "105988 Mathisen Elisabeth"
                ],
                flight_num: "DY537"
            ),
            crew_ground_event: []
        )
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
        
        // Preview with ground event crew
        CrewView(
            crew: Crew(cockpit: [], cabin: [], flight_num: nil),
            crew_ground_event: [
                "10415 Seljås Svein Oddvar",
                "105943 Szwagrzak Katarzyna",
                "105988 Mathisen Elisabeth",
                "10930 Borrebæk Stig",
                "11606 Myhre Knut Olav",
                "11799 Pedersen Geir Kristian",
                "11916 Jacobsen Ole Andreas",
                "12438 Skaar Magnus"
            ]
        )
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 2)
    }
} 
