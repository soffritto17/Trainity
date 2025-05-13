//
//  ContentView.swift
//  TrainityApp
//
//  Created by riccardo raffa on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    @State private var workoutPlan: [Exercise] = [] // Piano di allenamento che sarà passato

    var body: some View {
        TabView {
            // Prima schermata: Daily Challenge
            DailyChallengeView()
                .tabItem {
                    Label("Daily Challenge", systemImage: "bolt.fill")
                }

            // Seconda schermata: Customize Workout
            CustomizeWorkoutView(workoutPlan: $workoutPlan)
                .tabItem {
                    Label("Customize", systemImage: "slider.horizontal.3")
                }

            // Terza schermata: My Workout
            MyWorkoutView(workoutPlan: workoutPlan)
                .tabItem {
                    Label("My Workout", systemImage: "heart.fill")
                }
        }
    }
}


#Preview {
    ContentView()
}
