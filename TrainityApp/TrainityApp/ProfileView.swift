//
//  ProfileView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 15/05/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var editingNickname = false
    @State private var newNickname = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Profilo header
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .frame(width: 100, height: 100)
                                
                                Text(String(workoutManager.nickname.prefix(1)))
                                    .font(.system(size: 50, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.top)
                            
                            if editingNickname {
                                HStack {
                                    TextField("Nickname", text: $newNickname)
                                        .font(.title2)
                                        .multilineTextAlignment(.center)
                                        .padding(10)
                                        .background(Color.white)
                                        .cornerRadius(8)
                                    
                                    Button(action: {
                                        if !newNickname.isEmpty {
                                            workoutManager.nickname = newNickname
                                        }
                                        editingNickname = false
                                    }) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    }
                                }
                                .padding(.horizontal, 50)
                            } else {
                                HStack {
                                    Text(workoutManager.nickname)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    
                                    Button(action: {
                                        newNickname = workoutManager.nickname
                                        editingNickname = true
                                    }) {
                                        Image(systemName: "pencil.circle")
                                            .font(.title3)
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    }
                                }
                            }
                            
                            HStack(spacing: 30) {
                                VStack {
                                    Text("\(workoutManager.totalWorkoutsCompleted)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    Text("Allenamenti")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                VStack {
                                    Text("\(workoutManager.badgesEarned)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    Text("Badge")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        
                        // Sezione badge
                        VStack(alignment: .leading) {
                            Text("I tuoi Badge")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                                ForEach(workoutManager.badges) { badge in
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(badge.isEarned ? Color(red: 0.1, green: 0.4, blue: 0.4) : Color.gray.opacity(0.3))
                                                .frame(width: 70, height: 70)
                                            
                                            Image(systemName: badge.imageName)
                                                .font(.system(size: 30))
                                                .foregroundColor(badge.isEarned ? .white : .gray)
                                        }
                                        
                                        Text(badge.name)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }}}}

#Preview {
    ProfileView()
}
