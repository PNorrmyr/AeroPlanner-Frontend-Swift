//
//  AeroPlannerApp.swift
//  AeroPlanner
//
//  Created by Philip Norrmyr on 2025-05-08.
//

import SwiftUI

@main
struct AeroPlannerApp: App {
    @StateObject private var userService = UserService()
    
    var body: some Scene {
        WindowGroup {
            if userService.currentUser != nil {
                ContentView()
            } else {
                LoginView()
            }
        }
    }
}
