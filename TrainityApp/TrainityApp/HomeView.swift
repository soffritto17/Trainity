//
//  HomeView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("TRAINITY")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                        .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    HStack(spacing: 20) {
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "figure.run")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            
                            Text("Daily\nChallenge")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(width: 120, height: 150)
                        .background(Color(red: 0.9, green: 0.95, blue: 0.95))
                        .cornerRadius(10)
                        
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.7, green: 0.9, blue: 0.9))
                                    .frame(width: 80, height: 80)
                                
                                Image(systemName: "figure.yoga")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                            
                            Text("How to\nimprove")
                                .multilineTextAlignment(.center)
                                .font(.system(size: 16, weight: .medium))
                        }
                        .frame(width: 120, height: 150)
                        .background(Color(red: 0.9, green: 0.95, blue: 0.95))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "dumbbell")
                                .font(.title2)
                            Text("My Workouts")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .background(Color(red: 0.7, green: 0.9, blue: 0.9))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                                .font(.title2)
                            Text("How to Improve")
                                .font(.headline)
                            Spacer()
                        }
                        .padding()
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .background(Color(red: 0.7, green: 0.9, blue: 0.9))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Progress bar
                    VStack(alignment: .trailing) {
                        ZStack(alignment: .leading) {
                            Capsule()
                                .frame(height: 10)
                                .foregroundColor(Color(red: 0.7, green: 0.9, blue: 0.9))
                            
                            Capsule()
                                .frame(width: CGFloat(workoutManager.progress) / 100 * UIScreen.main.bounds.width * 0.8, height: 10)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        }
                        
                        Text("\(workoutManager.progress) / 100")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    HomeView()
}
