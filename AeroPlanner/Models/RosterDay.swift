import Foundation

struct RosterDay: Identifiable, Codable {
    let id = UUID()
    let date: String
    let duty: String
    let check_in: String?
    let check_out: String?
    let flights: [Flight]
    let time_limits: [String: String]
    let info: [String]
    let hotel: [String]
    let crew: Crew
} 