//
//  MyWorkoutView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct MyWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.7, green: 0.9, blue: 0.9))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    }
                    .padding(.top, 30)
                    
                    Text("My Workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    // Display selected workout or first workout if available
                    if let workout = selectedWorkout ?? workoutManager.savedWorkouts.first {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dumbbell.fill")
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Text(workout.goal)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Text("\(workout.duration) min")
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Spacer()
                                Text("\(workout.exercises.count)")
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                            
                            ForEach(workout.exercises) { exercise in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    
                                    Text(exercise.name)
                                        .font(.headline)
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    
                                    Spacer()
                                    
                                    Text("\(exercise.sets)x \(exercise.reps)")
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                }
                                .padding(.vertical, 5)
                            }
                            
                            Button(action: {
                                // Start workout action
                            }) {
                                Text("Start Workout")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    } else {
                        Text("No workouts saved")
                            .foregroundColor(.gray)
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    MyWorkoutView()
}
