import SwiftUI

struct FlightCardView: View {
    let flight: Flight
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .center) {
                Text(flight.departure)
                    .font(.system(size: 20, weight: .bold))
                Spacer(minLength: 6)
                Rectangle()
                    .frame(width: 75, height: 1)
                    .foregroundColor(.gray)
                Spacer(minLength: 4)
                Image(systemName: "airplane")
                    .foregroundColor(.blue)
                Spacer(minLength: 4)
                Rectangle()
                    .frame(width: 75, height: 1)
                    .foregroundColor(.gray)
                Spacer(minLength: 6)
                Text(flight.arrival)
                    .font(.system(size: 20, weight: .bold))
            }
            HStack(alignment: .center) {
                Text(timeString(flight.dep_time))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text(flight.flight_num)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
                Text(timeString(flight.arr_time))
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
        }
        .padding(10)
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color(.systemGray4).opacity(0.3), radius: 2, x: 0, y: 1)
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
    FlightCardView(flight: Flight(
        flight_num: "DY1858",
        departure: "BGO",
        arrival: "FCO",
        dep_time: "0630",
        arr_time: "0940",
        ac_type: "737NG"
    ))
} 
