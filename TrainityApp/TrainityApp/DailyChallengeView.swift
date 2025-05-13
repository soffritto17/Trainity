//
//  DailyChallengeView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct DailyChallengeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        ZStack {
            Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                Text("Daily\nChallenge")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 40)
                
                ZStack {
                    Circle()
                        .fill(Color(red: 0.7, green: 0.9, blue: 0.9))
                        .frame(width: 120, height: 120)
                        .shadow(radius: 5)
                    
                    Image(systemName: "dumbbell.fill")
                        .font(.system(size: 50))
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                
                HStack(spacing: 15) {
                    ForEach(0..<7) { day in
                        let weekdays = ["S", "M", "T", "W", "T", "S", "S"]
                        ZStack {
                            Circle()
                                .fill(workoutManager.dailyChallengeCompleted[day] ? Color(red: 0.1, green: 0.4, blue: 0.4) : Color(red: 0.7, green: 0.9, blue: 0.9))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color(red: 0.1, green: 0.4, blue: 0.4), lineWidth: 2)
                                )
                            
                            Text(weekdays[day])
                                .foregroundColor(workoutManager.dailyChallengeCompleted[day] ? .white : Color(red: 0.1, green: 0.4, blue: 0.4))
                                .font(.headline)
                        }
                    }
                }
                
                Text("1 / 7 Completed")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Spacer()
                
                Button(action: {
                    // Action to mark challenge as completed
                    workoutManager.dailyChallengeCompleted[1] = true
                }) {
                    Text("Complete")
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
    }
}
