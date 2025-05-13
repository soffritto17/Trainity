//
//  CustomizeWorkoutView.swift
//  TrainityApp
//
//  Created by riccardo raffa on 13/05/25.
//

import SwiftUI

struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
    var sets: Int = 3
    var restTime: Int = 60 // Tempo di recupero in secondi
}

struct CustomizeWorkoutView: View {
    @Binding var workoutPlan: [Exercise] // Passato da ContentView
    
    @State private var exercises = [
        Exercise(name: "Push-ups"),
        Exercise(name: "Squats"),
        Exercise(name: "Russian twists"),
        Exercise(name: "Mountain Climbers"),
        Exercise(name: "Diamond Push-ups"),
        Exercise(name: "Shoulder Push-ups")
    ]
    
    var body: some View {
        VStack {
            Text("Customize Workout")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            List {
                ForEach($exercises) { $exercise in
                    HStack {
                        Toggle(isOn: $exercise.isSelected) {
                            Text(exercise.name)
                        }
                        
                        if exercise.isSelected {
                            VStack {
                                HStack {
                                    Text("Sets")
                                    Stepper(value: $exercise.sets, in: 1...5) {
                                        Text("\(exercise.sets)")
                                    }
                                }
                                
                                HStack {
                                    Text("Rest Time (sec)")
                                    Stepper(value: $exercise.restTime, in: 30...180, step: 30) {
                                        Text("\(exercise.restTime)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Button("Confirm Workout") {
                // Filtra gli esercizi selezionati e salva nel workoutPlan
                workoutPlan = exercises.filter { $0.isSelected }
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
    }
}
