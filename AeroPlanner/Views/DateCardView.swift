import SwiftUI

struct DateCardView: View {
    let rosterDay: RosterDay
    @State private var showDetail = false
    @State private var selectedFlight: Flight? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(formattedDate(rosterDay.date))
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.blue)
                Spacer()
                if let checkIn = rosterDay.check_in {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 16, weight: .medium))
                        Text(timeString(checkIn))
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                if let checkOut = rosterDay.check_out {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.right.circle")
                            .foregroundColor(.red)
                            .font(.system(size: 16, weight: .medium))
                        Text(timeString(checkOut))
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            }
            Divider()
            VStack(spacing: 8) {
                ForEach(rosterDay.flights) { flight in
                    Button(action: {
                        selectedFlight = flight
                        showDetail = true
                    }) {
                        FlightCardView(flight: flight)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 4)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .sheet(isPresented: $showDetail) {
            DayDetailView(rosterDay: rosterDay)
        }
    }
    
    func formattedDate(_ date: String) -> String {
        // "2025-05-18" -> "Su. 18.05"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let d = formatter.date(from: date) {
            let weekday = Calendar.current.shortWeekdaySymbols[Calendar.current.component(.weekday, from: d)-1]
            let day = Calendar.current.component(.day, from: d)
            let month = Calendar.current.component(.month, from: d)
            return String(format: "%@. %02d.%02d", String(weekday.prefix(2)), day, month)
        }
        return date
    }
    
    func timeString(_ time: String?) -> String {
        guard let time = time, time.count >= 3 else { return "" }
        let clean = time.trimmingCharacters(in: CharacterSet(charactersIn: "!"))
        if clean.count == 4 {
            let h = clean.prefix(2)
            let m = clean.suffix(2)
            return "\(h):\(m)"
        }
        return clean
    }
}



struct SectionCard<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
        .shadow(color: Color(.systemGray4).opacity(0.2), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    DateCardView(rosterDay: RosterDay(
        date: "2025-05-18",
        duty: "FlD",
        check_in: "0530",
        check_out: "!1615",
        flights: [
            Flight(flight_num: "DY1858", departure: "BGO", arrival: "FCO", dep_time: "0630", arr_time: "0940", ac_type: "737NG"),
            Flight(flight_num: "DY1859", departure: "FCO", arrival: "BGO", dep_time: "1025", arr_time: "1340", ac_type: "737NG"),
            Flight(flight_num: "DH/DY623", departure: "BGO", arrival: "OSL", dep_time: "1500", arr_time: "1555", ac_type: nil)
        ],
        time_limits: [:],
        info: ["To c/m:, Autorized by, flight OPS, to operate as, Picus in May, 2025 by CP, Vikse Lien"],
        hotel: ["H1"],
        crew: Crew(
            cockpit: ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"],
            cabin: ["10355 Mosfjeld Morten", "103830 Duncan Fiona Catherine"],
            flight_num: "DY1858"
        )
    ))
} 
