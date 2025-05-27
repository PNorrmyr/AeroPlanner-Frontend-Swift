import SwiftUI

struct DateListView: View {
    let rosterDays: [RosterDay]
    @State private var selectedDate: Date?
    @State private var scrollProxy: ScrollViewProxy?
    @State private var hasScrolledToToday = false
    
    private func generateDateRange() -> [String] {
        let calendar = Calendar.current
        let today = Date()
        var dates: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for dayOffset in -180...180 {
            if let date = calendar.date(byAdding: .day, value: dayOffset, to: today) {
                dates.append(dateFormatter.string(from: date))
            }
        }
        return dates
    }
    
    private func getRosterDay(for date: String) -> RosterDay? {
        return rosterDays.first { $0.date == date }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(generateDateRange(), id: \.self) { dateString in
                        if let rosterDay = getRosterDay(for: dateString) {
                            NavigationLink(destination: DayDetailView(rosterDay: rosterDay)) {
                                DateCardView(rosterDay: rosterDay)
                            }
                            .buttonStyle(PlainButtonStyle())
                        } else {
                            DateCardView(rosterDay: RosterDay(
                                date: dateString,
                                duty: "",
                                check_in: nil,
                                check_out: nil,
                                flights: [],
                                time_limits: [:],
                                info: [],
                                hotel: [],
                                crew: Crew(cockpit: [], cabin: [], flight_num: ""),
                                crew_ground_event: []
                            ))
                        }
                    }
                }
                .padding([.leading, .trailing, .bottom])
            }
            .background(Color(.systemGray6))
            .onAppear {
                scrollProxy = proxy
                if !hasScrolledToToday {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let today = dateFormatter.string(from: Date())
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            proxy.scrollTo(today, anchor: .top)
                        }
                        hasScrolledToToday = true
                    }
                }
            }
        }
    }
}

#Preview {
    DateListView(rosterDays: [
        RosterDay(
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
            time_limits: [
                "FT": "06:25",
                "DT": "10:45"
            ],
            info: ["Test info"],
            hotel: ["H1"],
            crew: Crew(
                cockpit: ["16704 Flaathen Kristoffer Wårås"],
                cabin: ["10355 Mosfjeld Morten"],
                flight_num: "DY1858"
            ),
            crew_ground_event: []
        )
    ])
} 
