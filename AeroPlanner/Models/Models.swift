import Foundation

// MARK: - Models
struct RosterDay: Codable, Identifiable {
    let date: String
    let duty: String
    let check_in: String?
    let check_out: String?
    let flights: [Flight]
    let time_limits: [String: String]
    let info: [String]
    let hotel: [String]
    let crew: Crew
    
    var id: String { date }
}

struct Flight: Codable, Identifiable {
    let flight_num: String
    let departure: String
    let arrival: String
    let dep_time: String
    let arr_time: String
    let ac_type: String?
    
    var id: String { flight_num + departure + dep_time }
}

struct Crew: Codable {
    let cockpit: [String]
    let cabin: [String]
    let flight_num: String?
}


struct RosterDayRaw: Codable {
    let duty: String
    let check_in: String?
    let check_out: String?
    let flights: [Flight]
    let time_limits: [String: String]
    let info: [String]
    let hotel: [String]
    let crew: Crew
    
    func toRosterDay(date: String) -> RosterDay {
        RosterDay(
            date: date,
            duty: duty,
            check_in: check_in,
            check_out: check_out,
            flights: flights,
            time_limits: time_limits,
            info: info,
            hotel: hotel,
            crew: crew
        )
    }
} 
