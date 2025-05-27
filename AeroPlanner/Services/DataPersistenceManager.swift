import Foundation

class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    private let fileManager = FileManager.default
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    private init() {}
    
    private func getRosterDataFileName(for userId: String) -> String {
        return "roster_data_\(userId).json"
    }
    
    // save data for specific user
    func saveRosterDays(_ rosterDays: [RosterDay], for userId: String) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(rosterDays)
            let fileURL = documentsPath.appendingPathComponent(getRosterDataFileName(for: userId))
            try data.write(to: fileURL)
        } catch {
            print("Error saving roster data: \(error)")
        }
    }
    
    // Check if user has data already saved and fetches it
    func loadRosterDays(for userId: String) -> [RosterDay]? {
        let fileURL = documentsPath.appendingPathComponent(getRosterDataFileName(for: userId))
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let rosterDays = try decoder.decode([RosterDay].self, from: data)
            return rosterDays
        } catch {
            print("Error loading roster data: \(error)")
            return nil
        }
    }
    
    func clearRosterData(for userId: String) {
        let fileURL = documentsPath.appendingPathComponent(getRosterDataFileName(for: userId))
        try? fileManager.removeItem(at: fileURL)
    }
    
    func clearAllRosterData() {
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsPath, includingPropertiesForKeys: nil)
            for file in files where file.lastPathComponent.starts(with: "roster_data_") {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("Error deleting cached roster data: \(error)")
        }
    }
} 
