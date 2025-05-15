//
//  CustomizeWorkoutView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct CustomizeWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var duration: Int = 30
    @State private var exerciseCount: Int = 4
    @State private var restTime: Int = 30
    @State private var goal: String = "Build Muscle"
    @State private var showWorkout = false
    @State private var generatedWorkout: Workout?
    
    var body: some View {
        ZStack {
            Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Customize\nWorkout")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 40)
                
                Text("* Select your preferences")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                // Duration
                HStack {
                    Label("Duration", systemImage: "clock")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Spacer()
                    
                    Text("\(duration) min")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Exercise Count
                HStack {
                    Label("Exercises", systemImage: "list.bullet")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Spacer()
                    
                    Text("\(exerciseCount)")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Rest Time
                HStack {
                    Label("Rest Time", systemImage: "timer")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Spacer()
                    
                    Text("\(restTime) sec")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                // Goal
                HStack {
                    Label("Goal", systemImage: "person.fill")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Spacer()
                    
                    Text(goal)
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    generatedWorkout = workoutManager.generateWorkout(
                        duration: duration,
                        exerciseCount: exerciseCount,
                        goal: goal,
                        restTime: restTime
                    )
                    showWorkout = true
                }) {
                    Text("Generate Workout")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .sheet(isPresented: $showWorkout, content: {
            if let workout = generatedWorkout {
                WorkoutDetailView(workout: workout)
                    .environmentObject(workoutManager)
            }
        })
    }
}



#Preview {
    CustomizeWorkoutView()
}
