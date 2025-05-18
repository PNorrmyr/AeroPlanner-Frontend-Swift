import Foundation

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    private let rosterDataFileName = "roster_data.json"
    
    private init() {}
    
    func saveRosterDays(_ rosterDays: [RosterDay]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(rosterDays)
            let fileURL = documentsPath.appendingPathComponent(rosterDataFileName)
            try data.write(to: fileURL)
        } catch {
            print("Fel vid sparande av roster-data: \(error)")
        }
    }
    
    func loadRosterDays() -> [RosterDay]? {
        let fileURL = documentsPath.appendingPathComponent(rosterDataFileName)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let rosterDays = try decoder.decode([RosterDay].self, from: data)
            return rosterDays
        } catch {
            print("Fel vid laddning av roster-data: \(error)")
            return nil
        }
    }
    
    func clearRosterData() {
        let fileURL = documentsPath.appendingPathComponent(rosterDataFileName)
        try? fileManager.removeItem(at: fileURL)
    }
} 