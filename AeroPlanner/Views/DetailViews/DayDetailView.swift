import SwiftUI

struct DayDetailView: View {
    let rosterDay: RosterDay
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                VStack(alignment: .center, spacing: 8) {
                    Text(formattedDateLong(rosterDay.date))
                        .font(.title)
                        .fontDesign(.rounded)
                        .foregroundColor(.blue)
                    HStack(spacing: 16) {
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
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                
                // Flights
                VStack(alignment: .leading, spacing: 12) {
                    Text("Flights")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    FlightSectionView(flights: rosterDay.flights)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                
                // Time limits
                if !rosterDay.time_limits.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Time Limits")
                            .font(.title)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        TimeLimitsView(timeLimits: rosterDay.time_limits)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                }
                
                // Hotel
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hotel")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HotelView(hotels: rosterDay.hotel)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                
                // Crew
                VStack(alignment: .leading, spacing: 12) {
                    Text("Crew")
                        .font(.title)
                        .fontDesign(.rounded)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    CrewView(crew: rosterDay.crew)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                
                // Info
                if !rosterDay.info.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Additional Information")
                            .font(.title)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        AdditionalInfoView(infoItems: rosterDay.info)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    func formattedDateLong(_ date: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let d = formatter.date(from: date) {
            let weekday = Calendar.current.weekdaySymbols[Calendar.current.component(.weekday, from: d)-1]
            let day = Calendar.current.component(.day, from: d)
            let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: d)-1]
            let year = Calendar.current.component(.year, from: d)
            
            let daySuffix: String
            switch day {
            case 1, 21, 31: daySuffix = "st"
            case 2, 22: daySuffix = "nd"
            case 3, 23: daySuffix = "rd"
            default: daySuffix = "th"
            }
            
            return String(format: "%@, %@ %d%@, %d", weekday, month, day, daySuffix, year)
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

#Preview {
    DayDetailView(rosterDay: RosterDay(
        date: "2025-05-18",
        duty: "FlD",
        check_in: "0530",
        check_out: "!1615",
        flights: [
            Flight(flight_num: "DY1858", departure: "BGO", arrival: "FCO", dep_time: "0630", arr_time: "0940", ac_type: "737NG"),
            Flight(flight_num: "DY1859", departure: "FCO", arrival: "BGO", dep_time: "1025", arr_time: "1340", ac_type: "737NG")
        ],
        time_limits: [
            "FT": "06:25",
            "DT": "10:45",
            "FDT": "08:10",
            "FDP": "08:10",
            "RT": "19/0415",
            "BRK": "015:55",
            "mFDP": "12:30",
            "xFDP": "00:00",
            "DTwSB": "10:45"
        ],
        info: ["To c/m:, Autorized by, flight OPS, to operate as, Picus in May, 2025 by CP, Vikse Lien"],
        hotel: ["H1"],
        crew: Crew(
            cockpit: ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"],
            cabin: ["10355 Mosfjeld Morten", "103830 Duncan Fiona Catherine"],
            flight_num: "DY1858"
        )
    ))
} 
