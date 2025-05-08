import Foundation

struct Flight: Identifiable, Codable {
    let id = UUID()
    let flight_num: String
    let departure: String
    let arrival: String
    let dep_time: String
    let arr_time: String?
    let ac_type: String?
} 