import SwiftUI

struct FlightSectionView: View {
    let flights: [Flight]
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(flights) { flight in
                FlightCardView(flight: flight)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FlightSectionView(flights: [
        Flight(flight_num: "DY1858", departure: "BGO", arrival: "FCO", dep_time: "0630", arr_time: "0940", ac_type: "737NG"),
        Flight(flight_num: "DY1859", departure: "FCO", arrival: "BGO", dep_time: "1025", arr_time: "1340", ac_type: "737NG")
    ])
    .padding()
    .background(Color(.systemBackground))
    .cornerRadius(16)
    .shadow(radius: 2)
} 