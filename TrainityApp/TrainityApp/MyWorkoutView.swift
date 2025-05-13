//
//  MyWorkoutView.swift
//  TrainityApp
//
//  Created by riccardo raffa on 13/05/25.
//


import SwiftUI

struct MyWorkoutView: View {
    @State var workoutPlan: [Exercise]
    @State private var currentExerciseIndex = 0
    @State private var isResting = false
    @State private var timeRemaining = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack {
            Text("My Workout")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            if currentExerciseIndex < workoutPlan.count {
                let currentExercise = workoutPlan[currentExerciseIndex]
                
                Text("Exercise: \(currentExercise.name)")
                    .font(.title2)
                    .padding()
                
                Text("Sets: \(currentExercise.sets)")
                    .font(.title3)
                
                Text(isResting ? "Resting" : "Working")
                    .foregroundColor(isResting ? .green : .red)
                    .font(.title2)
                    .padding()
                
                Text("Time Remaining: \(timeRemaining) sec")
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    startWorkout()
                }) {
                    Text("Start")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }
            }
        }
    }
    
    func startWorkout() {
        // Imposta il tempo di recupero per il primo esercizio
        let firstExercise = workoutPlan[currentExerciseIndex]
        timeRemaining = firstExercise.restTime
        
        // Avvia il cronometro
        isResting = false
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                // Passa al prossimo esercizio o al periodo di riposo
                if isResting {
                    // Cambia esercizio
                    currentExerciseIndex += 1
                    if currentExerciseIndex < workoutPlan.count {
                        let nextExercise = workoutPlan[currentExerciseIndex]
                        timeRemaining = nextExercise.restTime
                    }
                } else {
                    // Inizia il recupero
                    isResting = true
                    timeRemaining = workoutPlan[currentExerciseIndex].restTime
                }
            }
        }
    }
}


