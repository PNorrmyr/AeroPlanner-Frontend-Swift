import SwiftUI

struct DateCardView: View {
    let rosterDay: RosterDay
    @State private var showDetail = false
    @State private var selectedFlight: Flight? = nil
    
    var isOff: Bool {
        rosterDay.duty.lowercased() == "off"
    }
    
    var body: some View {
        VStack(spacing: isOff ? 4 : 12) {
            HStack {
                Text(formattedDate(rosterDay.date))
                    .font(.headline)
                    .fontDesign(.rounded)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(isOff ? "OFF" : rosterDay.duty)
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(isOff ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            
            // Check in/out och flygningar
            if isOff {
                Text("OFF")
                    .font(.title2)
                    .fontDesign(.rounded)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                HStack(spacing: 16) {
                    if !rosterDay.flights.isEmpty {
                        Text("\(rosterDay.flights.count) flights")
                            .font(.subheadline)
                            .fontDesign(.rounded)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if let checkIn = rosterDay.check_in, checkIn.uppercased() != "<NA>" {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.green)
                            Text(checkIn)
                                .font(.subheadline)
                        }
                    }
                    
                    if let checkOut = rosterDay.check_out, checkOut.uppercased() != "<NA>" {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right.circle.fill")
                                .foregroundColor(.red)
                            Text(checkOut)
                                .font(.subheadline)
                        }
                    }
                }
                
                if !rosterDay.flights.isEmpty {
                    FlightSectionView(flights: rosterDay.flights)
                }
            }
        }
        .padding()
        .frame(height: isOff ? 80 : nil)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
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
    VStack {
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-18",
            duty: "FlD",
            check_in: "0530",
            check_out: "1615",
            flights: [
                Flight(
                    flight_num: "DY1858",
                    departure: "BGO",
                    arrival: "FCO",
                    dep_time: "0630",
                    arr_time: "0940",
                    ac_type: "737NG"
                )
            ],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: "")
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-19",
            duty: "off",
            check_in: "<NA>",
            check_out: "<NA>",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: "")
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 
