//
//  HomeView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    // Rimuovi queste variabili di stato poiché non saranno più necessarie con NavigationLink
    // @State private var showDailyChallenge = false
    // @State private var showCreateWorkout = false
    
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
                        .padding(.bottom, 30)
                        .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    // Sostituisci il Button con NavigationLink
                    NavigationLink(destination: DailyChallengeView().environmentObject(workoutManager)) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "flame.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Daily Challenge")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                Text("Complete daily workouts to earn badges")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Sostituisci il secondo Button con NavigationLink
                    NavigationLink(destination: CustomizeWorkoutView().environmentObject(workoutManager)) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .frame(width: 60, height: 60)
                                
                                Image(systemName: "dumbbell.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("My Workouts")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                Text("Create and manage your custom workouts")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    
                    // Progress overview (resta invariato)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Progress")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        HStack {
                            VStack {
                                Text("\(workoutManager.totalWorkoutsCompleted)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Text("Workouts")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .frame(height: 40)
                            
                            VStack {
                                Text("\(workoutManager.weeklyStreak)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Text("Days Streak")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            
                            Divider()
                                .frame(height: 40)
                            
                            VStack {
                                Text("\(workoutManager.badgesEarned)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                Text("Badges")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WorkoutManager())
}
