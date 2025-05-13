//
//  WorkoutDetailView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text(workout.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 40)
                
                VStack(alignment: .leading, spacing: 15) {
                    ForEach(workout.exercises) { exercise in
                        HStack {
                            Text(exercise.name)
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            
                            Spacer()
                            
                            Text("\(exercise.sets)x \(exercise.reps)")
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                HStack(spacing: 20) {
                    Button(action: {
                        workoutManager.savedWorkouts.append(workout)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Workout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 0.1, green: 0.4, blue: 0.4), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
