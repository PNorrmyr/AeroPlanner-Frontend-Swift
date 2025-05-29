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
    @State private var showDocumentPicker = false
    @State private var rosterDays: [RosterDay] = []
    @StateObject private var apiService = APIService()
    @StateObject private var userService = UserService()
    @State private var showError = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    HStack {
                        Button(action: { withAnimation { showSidebar.toggle() } }) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 23, weight: .light))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                        }
                        Spacer()
                        
                        Text("AeroPlanner")
                            .font(.system(size: 26, weight: .medium))
                            .foregroundColor(.white)
                            .tracking(1.2)
                            .shadow(color: Color.black.opacity(0.18), radius: 1, x: 0, y: 1)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "calendar")
                                .font(.system(size: 25, weight: .light))
                                .foregroundColor(.white)
                                .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    .frame(height: 50)
                    .background(LinearGradient.aeroHeader)
                    
                    DateListView(rosterDays: rosterDays)
                }
                .disabled(showSidebar)
                
                if showSidebar {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showSidebar = false } }
                }
                
                if let currentUser = userService.currentUser {
                    SidebarView(onUpload: { showDocumentPicker = true }, onCacheCleared: {
                        withAnimation {
                            rosterDays = []
                            DataPersistenceManager.shared.clearRosterData(for: currentUser.id.uuidString)
                        }
                    })
                    .offset(x: showSidebar ? 0 : -320)
                    .animation(.easeInOut, value: showSidebar)
                }
                
                if apiService.isLoading {
                    ZStack {
                        Color.black.opacity(0.1).ignoresSafeArea()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(2)
                    }
                    .zIndex(100)
                }
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
                        Task {
                            await uploadPDF(url: url)
                        }
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
                Text(apiService.error ?? "An unknown error occurred")
            }
        }
        .onAppear {
            if let currentUser = userService.currentUser,
               let savedRosterDays = DataPersistenceManager.shared.loadRosterDays(for: currentUser.id.uuidString) {
                rosterDays = savedRosterDays
            }
        }
    }
    
    func uploadPDF(url: URL) async {
        guard let currentUser = userService.currentUser else { return }
        
        do {
            let newDays = try await apiService.uploadPDF(url: url)
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                var updatedDays = rosterDays
                
                for newDay in newDays {
                    if let existingIndex = updatedDays.firstIndex(where: { $0.date == newDay.date }) {
                        updatedDays[existingIndex] = newDay
                    } else {
                        updatedDays.append(newDay)
                    }
                }
                
                rosterDays = updatedDays.sorted { $0.date < $1.date }
                
                showSidebar = false
                DataPersistenceManager.shared.saveRosterDays(rosterDays, for: currentUser.id.uuidString)
            }
        } catch {
            apiService.error = error.localizedDescription
            showError = true
        }
    }
}

struct LoadingView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            Image(systemName: "arrow.up.doc.fill")
                .font(.system(size: 50))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("Uploading PDF...")
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
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

extension LinearGradient {
    static let aeroHeader = LinearGradient(
        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

#Preview {
    ContentView()
}
