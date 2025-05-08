//
//  ContentView.swift
//  AeroPlanner
//
//  Created by Philip Norrmyr on 2025-05-08.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var showSidebar = false
    @State private var roster: [RosterDay] = demoRoster
    @State private var showDocumentPicker = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { withAnimation { showSidebar.toggle() } }) {
                            Image(systemName: "line.horizontal.3")
                                .font(.system(size: 28))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("AeroPlanner")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                        Spacer()
                        Rectangle().frame(width: 28, height: 28).opacity(0) // Placeholder
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .frame(height: 56)
                    .background(Color.blue)
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(roster) { day in
                                DateCardView(rosterDay: day)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .disabled(showSidebar)
                if showSidebar {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showSidebar = false } }
                }
                SidebarView(onUpload: { showDocumentPicker = true })
                    .offset(x: showSidebar ? 0 : -320)
                    .animation(.easeInOut, value: showSidebar)
            }
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.width > 60 {
                        withAnimation { showSidebar = true }
                    } else if value.translation.width < -60 {
                        withAnimation { showSidebar = false }
                    }
                })
            .navigationBarHidden(true)
            .sheet(isPresented: $showDocumentPicker) {
                DocumentPicker { url in
                    if let url = url {
                        uploadPDF(url: url)
                    }
                }
            }
        }
    }
    
    func uploadPDF(url: URL?) {
        //TODO implement real api connection
        if let data = mockJSON.data(using: .utf8) {
            if let decoded = decodeRoster(from: data) {
                roster = decoded.sorted { $0.date < $1.date }
            }
        }
    }
    
    func decodeRoster(from data: Data) -> [RosterDay]? {
        do {
            let dict = try JSONDecoder().decode([String: RosterDayRaw].self, from: data)
            let days = dict.map { (key, value) -> RosterDay in
                value.toRosterDay(date: key)
            }
            return days
        } catch {
            print("JSON decode error: \(error)")
            return nil
        }
    }
}

struct DocumentPicker: UIViewControllerRepresentable {
    var completion: (URL?) -> Void
    func makeCoordinator() -> Coordinator { Coordinator(completion: completion) }
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let completion: (URL?) -> Void
        init(completion: @escaping (URL?) -> Void) { self.completion = completion }
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            completion(urls.first)
        }
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            completion(nil)
        }
    }
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
        RosterDay(date: date, duty: duty, check_in: check_in, check_out: check_out, flights: flights, time_limits: time_limits, info: info, hotel: hotel, crew: crew)
    }
}

// Demo-data för förhandsvisning
let demoRoster: [RosterDay] = [
    RosterDay(date: "2025-05-18", duty: "FlD", check_in: "0530", check_out: "!1615", flights: [
        Flight(flight_num: "DY1858", departure: "BGO", arrival: "FCO", dep_time: "0630", arr_time: "0940", ac_type: "737NG"),
        Flight(flight_num: "DY1859", departure: "FCO", arrival: "BGO", dep_time: "1025", arr_time: "1340", ac_type: "737NG"),
        Flight(flight_num: "DH/DY623", departure: "BGO", arrival: "OSL", dep_time: "1500", arr_time: "1555", ac_type: nil)
    ], time_limits: ["FT": "06:25", "DT": "10:45", "FDT": "08:10", "FDP": "08:10", "RT": "19/0415", "BRK": "015:55", "mFDP": "12:30", "xFDP": "00:00", "DTwSB": "10:45"], info: ["To c/m:, Autorized by, flight OPS, to operate as, Picus in May, 2025 by CP, Vikse Lien"], hotel: ["H1"], crew: Crew(cockpit: ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"], cabin: ["10355 Mosfjeld Morten", "103830 Duncan Fiona Catherine"], flight_num: "DY1858")),
    RosterDay(date: "2025-05-19", duty: "FlD", check_in: "0810", check_out: "1625", flights: [
        Flight(flight_num: "DY1362", departure: "OSL", arrival: "DUB", dep_time: "0910", arr_time: "!1030", ac_type: "737NG"),
        Flight(flight_num: "DY1363", departure: "DUB", arrival: "OSL", dep_time: "1110", arr_time: "!1420", ac_type: "737NG"),
        Flight(flight_num: "DY410", departure: "OSL", arrival: "AES", dep_time: "1510", arr_time: "1605", ac_type: "737NG")
    ], time_limits: [:], info: [], hotel: [], crew: Crew(cockpit: ["16704 Flaathen Kristoffer Wårås"], cabin: ["10355 Mosfjeld Morten"], flight_num: "DY1362"))
]

// Mock JSON-data (från användarens exempel, nu med dictionary för time_limits)
let mockJSON = """
{
  "2025-05-18": {
    "duty": "FlD",
    "check_in": "0530",
    "check_out": "!1615",
    "flights": [
      { "flight_num": "DY1858", "departure": "BGO", "arrival": "FCO", "dep_time": "0630", "arr_time": "0940", "ac_type": "737NG" },
      { "flight_num": "DY1859", "departure": "FCO", "arrival": "BGO", "dep_time": "1025", "arr_time": "1340", "ac_type": "737NG" },
      { "flight_num": "DH/DY623", "departure": "BGO", "arrival": "OSL", "dep_time": "1500", "arr_time": "1555", "ac_type": null }
    ],
    "time_limits": {
      "FT": "06:25",
      "DT": "10:45",
      "FDT": "08:10",
      "FDP": "08:10",
      "RT": "19/0415",
      "BRK": "015:55",
      "mFDP": "12:30",
      "xFDP": "00:00",
      "DTwSB": "10:45"
    },
    "info": [
      "To c/m:, Autorized by, flight OPS, to operate as, Picus in May, 2025 by CP, Vikse Lien"
    ],
    "hotel": ["H1"],
    "crew": {
      "cockpit": ["16704 Flaathen Kristoffer Wårås", "28719 Norrmyr Philip"],
      "cabin": ["10355 Mosfjeld Morten", "103830 Duncan Fiona Catherine"],
      "flight_num": "DY1858"
    }
  },
  "2025-05-19": {
    "duty": "FlD",
    "check_in": "0810",
    "check_out": "1625",
    "flights": [
      { "flight_num": "DY1362", "departure": "OSL", "arrival": "DUB", "dep_time": "0910", "arr_time": "!1030", "ac_type": "737NG" },
      { "flight_num": "DY1363", "departure": "DUB", "arrival": "OSL", "dep_time": "1110", "arr_time": "!1420", "ac_type": "737NG" },
      { "flight_num": "DY410", "departure": "OSL", "arrival": "AES", "dep_time": "1510", "arr_time": "1605", "ac_type": "737NG" }
    ],
    "time_limits": {},
    "info": [],
    "hotel": [],
    "crew": {
      "cockpit": ["16704 Flaathen Kristoffer Wårås"],
      "cabin": ["10355 Mosfjeld Morten"],
      "flight_num": "DY1362"
    }
  }
}
"""

#Preview {
    ContentView()
}
