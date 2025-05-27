import SwiftUI

struct DayDetailView: View {
    let rosterDay: RosterDay
    
    private let standbyDutyCodes = ["SBY", "MIS", "ASB", "SSB"]
    private let flightDutyCodes = ["C/I", "C/O", "PickUp", "DH", "Pick Up", "F1D"]
    private let groundDutyCodes = ["DG", "CBT", "RET3", "AID3", "TRA"]
    private let offDutyCodes = ["DOF", "OFF", "VAC", "ILL", "ILM", "NFF"]
    
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
        flightDutyCodes.contains(rosterDay.duty.uppercased()) || !rosterDay.flights.isEmpty
    }
    
    func getDutyDescription(_ duty: String) -> String {
        switch duty.uppercased() {
        case "DG": return "Dangerous Goods"
        case "CBT": return "Computer Based Training"
        case "TRA", "AID3": return "Classroom Training"
        case "RET3": return "Simulator"
        case "SBY": return "Standby"
        case "MIS": return "Minimum Standby"
        case "ASB": return "Additional Standby"
        case "SSB": return "Short Standby"
        default: return duty
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 20) {
                // Header Section
                VStack(alignment: .center, spacing: 8) {
                    Text(formattedDateLong(rosterDay.date))
                        .font(.title)
                        .fontDesign(.rounded)
                        .foregroundColor(.blue)
                    HStack(spacing: 16) {
                        if let checkIn = rosterDay.check_in, checkIn.uppercased() != "<NA>" {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 16, weight: .medium))
                                Text(timeString(checkIn))
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        if let checkOut = rosterDay.check_out, checkOut.uppercased() != "<NA>" {
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
                
                // Duty or Flights Section
                if !rosterDay.flights.isEmpty || rosterDay.duty.uppercased() == "F1D" {
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
                } else if !isOff {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Duty")
                            .font(.title)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(getDutyDescription(rosterDay.duty))
                            .font(.title2)
                            .fontDesign(.rounded)
                            .foregroundColor(.secondary)
                            .padding(.vertical, 8)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                }
                
                // Time Limits Section
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
                
                // Hotel Section
                if !rosterDay.hotel.isEmpty {
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
                }
                
                // Crew Section
                if !rosterDay.crew.cockpit.isEmpty || !rosterDay.crew.cabin.isEmpty || !rosterDay.crew_ground_event.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Crew")
                            .font(.title)
                            .fontDesign(.rounded)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        CrewView(crew: rosterDay.crew, crew_ground_event: rosterDay.crew_ground_event)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color(.systemGray4), radius: 4, x: 0, y: 2)
                }
                
                // Additional Info Section
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
        duty: "F1D",
        check_in: "0530",
        check_out: "1615",
        flights: [],
        time_limits: [
            "FT": "06:25",
            "DT": "10:45"
        ],
        info: ["Dangerous Goods Training"],
        hotel: [],
        crew: Crew(cockpit: ["28719 Philip Norrmyr"], cabin: [], flight_num: ""),
        crew_ground_event: []
    ))
} 
