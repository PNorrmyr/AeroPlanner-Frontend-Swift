import Foundation
import SwiftUI

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int, String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid server response"
        case .decodingError(let error):
            return "Error decoding data: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Server error (\(code)): \(message)"
        }
    }
}

@MainActor
final class APIService: ObservableObject {
    @Published var isLoading = false
    @Published var error: String?
    
    private let baseURL = "http://127.0.0.1:5001/api/data"
    
    func uploadPDF(url: URL) async throws -> [RosterDay] {
        isLoading = true
        error = nil
        
        defer {
            isLoading = false
        }
        
        guard let requestURL = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        // create the multipart form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Add PDF file
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(url.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        
        guard let pdfData = try? Data(contentsOf: url) else {
            throw APIError.networkError(NSError(domain: "PDFError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Could not read PDF file"]))
        }
        data.append(pdfData)
        
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = data
        
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            print("Server response status code: \(httpResponse.statusCode)")
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("Server response data: \(responseString)")
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let message = String(data: responseData, encoding: .utf8) ?? "Unknown error"
                throw APIError.serverError(httpResponse.statusCode, message)
            }
            
            // if response 200, decode it
            let decoder = JSONDecoder()
            do {
                // Date dict
                let dict = try decoder.decode([String: RosterDayRaw].self, from: responseData)
                
                // Date dict converts each key/value to a RosterDay
                let days = dict.map { (key, value) -> RosterDay in
                    value.toRosterDay(date: key)
                }
                return days.sorted { $0.date < $1.date }
            } catch {
                print("Decoding error details: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Key '\(key)' not found: \(context.debugDescription)")
                        throw APIError.decodingError(NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing required field: \(key)"]))
                    case .valueNotFound(let type, let context):
                        print("Value of type '\(type)' not found: \(context.debugDescription)")
                        throw APIError.decodingError(NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing value for type: \(type)"]))
                    case .typeMismatch(let type, let context):
                        print("Type '\(type)' mismatch: \(context.debugDescription)")
                        throw APIError.decodingError(NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data type for: \(type)"]))
                    case .dataCorrupted(let context):
                        print("Data corrupted: \(context.debugDescription)")
                        throw APIError.decodingError(NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Data is corrupted or in wrong format"]))
                    @unknown default:
                        throw APIError.decodingError(error)
                    }
                }
                throw APIError.decodingError(NSError(domain: "DecodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode server response"]))
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
} 
