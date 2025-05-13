//
//  ContentView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

// VISTE PRINCIPALI
import SwiftUI


struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            
            DailyChallengeView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Challenge", systemImage: "flame")
                }
            
            CustomizeWorkoutView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Customize", systemImage: "slider.horizontal.3")
                }
            
            MyWorkoutView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("My Workou", systemImage: "heart")
                }
        }
        .accentColor(Color(red: 0.1, green: 0.4, blue: 0.4))
    }
}
#Preview {
    ContentView()
}
