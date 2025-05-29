import SwiftUI

struct DateCardView: View {
    let rosterDay: RosterDay
    @State private var showDetail = false
    @State private var selectedFlight: Flight? = nil
    
    private let standbyDutyCodes = ["SBY", "MIS", "ASB", "SSB"]
    private let flightDutyCodes = ["C/I", "C/O", "PickUp", "DH", "Pick Up"]
    private let groundDutyCodes = ["DG", "CBT", "RET3", "AID3", "TRA"]
    private let offDutyCodes = ["DOF", "OFF", "VAC"]
    private let sickDutyCodes = ["ILL", "ILM", "SIC"]
    
    var isOff: Bool {
        offDutyCodes.contains(rosterDay.duty.uppercased()) || rosterDay.duty.isEmpty
    }
    
    var isStandby: Bool {
        standbyDutyCodes.contains(rosterDay.duty.uppercased())
    }
    
    var isGroundDuty: Bool {
        groundDutyCodes.contains(rosterDay.duty.uppercased())
    }
    
    var isFlightDuty: Bool {
        flightDutyCodes.contains(rosterDay.duty.uppercased())
    }
    
    var isSickDuty: Bool {
        sickDutyCodes.contains(rosterDay.duty.uppercased())
    }
    
    var dutyText: String {
        if rosterDay.duty.isEmpty {
            return "Off"
        }
        if isFlightDuty {
            return "F1D"
        }
        return rosterDay.duty
    }
    
    var displayText: String {
        if isOff || isSickDuty {
            if rosterDay.duty.isEmpty {
                return "No data"
            }
            switch rosterDay.duty.uppercased() {
            case "Off": return "Day Off"
            case "VAC": return "Vacation"
            case "ILL", "ILM", "SIC": return "Illness"
            default: return "Day Off"
            }
        } else if isStandby {
            return "Standby"
        } else if isGroundDuty {
            return "Ground Duty"
        }
        return rosterDay.duty
    }
    
    var dutyColor: Color {
        if isOff {
            return .gray
        } else if isStandby {
            return .orange
        } else if isGroundDuty {
            return .green
        } else if isFlightDuty {
            return .blue
        } else if isSickDuty {
            return .red
        }
        return .blue
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(formattedDate(rosterDay.date))
                    .font(.headline)
                    .fontDesign(.rounded)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Text(dutyText.uppercased())
                    .font(.subheadline)
                    .fontDesign(.rounded)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(dutyColor)
                    .cornerRadius(8)
            }
            
            HStack(spacing: 16) {
                if isOff || isStandby || isGroundDuty || isSickDuty {
                    Text(displayText)
                        .font(.title2)
                        .fontDesign(.rounded)
                        .foregroundColor(.secondary)
                } else if let flights = rosterDay.flights, !flights.isEmpty {
                    Text("\(flights.count) Flights")
                        .font(.title2)
                        .fontDesign(.rounded)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if !isOff {
                    if let checkIn = rosterDay.check_in, checkIn.uppercased() != "<NA>" {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(.green)
                            Text(checkIn)
                                .font(.subheadline)
                        }
                    }
                    
                    if let checkOut = rosterDay.check_out, checkOut.uppercased() != "<NA>" {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.right.circle")
                                .foregroundColor(.red)
                            Text(checkOut)
                                .font(.subheadline)
                        }
                    }
                }
            }
            
            if let flights = rosterDay.flights, !flights.isEmpty {
                FlightSectionView(flights: flights)
            }
        }
        .padding()
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
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: []
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-19",
            duty: "Sic",
            check_in: "<NA>",
            check_out: "<NA>",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: []
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-20",
            duty: "SBY",
            check_in: "0600",
            check_out: "1800",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: []
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-21",
            duty: "DG",
            check_in: "0600",
            check_out: "1800",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: ["10415 Seljås Svein Oddvar", "105943 Szwagrzak Katarzyna"]
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-22",
            duty: "VAC",
            check_in: "<NA>",
            check_out: "<NA>",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: []
        ))
        
        DateCardView(rosterDay: RosterDay(
            date: "2025-05-23",
            duty: "",
            check_in: "<NA>",
            check_out: "<NA>",
            flights: [],
            time_limits: [:],
            info: [],
            hotel: [],
            crew: Crew(cockpit: [], cabin: [], flight_num: ""),
            crew_ground_event: []
        ))
    }
    .padding()
    .background(Color(.systemGroupedBackground))
} 
