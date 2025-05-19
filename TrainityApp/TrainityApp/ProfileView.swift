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
                                        Image(systemName: "square.and.pencil")
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
                            
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
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
                                            .multilineTextAlignment(.center)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .onAppear {
                addNewBadges()
            }
            .navigationBarTitle("Profilo", displayMode: .inline)
        }
    }
    
    // Funzione per aggiungere i nuovi badge
    private func addNewBadges() {
        // Controlla se il primo nuovo badge è già presente
        if !workoutManager.badges.contains(where: { $0.name == "Costanza" }) {
            // Badge 1: Costanza
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Costanza",
                     description: "Completa allenamenti per 7 giorni consecutivi",
                     imageName: "figure.walk.motion",
                     isEarned: false)
            )
            
            // Badge 2: Forza
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Forza",
                     description: "Completa 10 allenamenti di forza",
                     imageName: "dumbbell.fill",
                     isEarned: false)
            )
            
            // Badge 3: Esploratore
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Esploratore",
                     description: "Prova 5 tipi diversi di allenamento",
                     imageName: "figure.hiking",
                     isEarned: false)
            )
            
            // Badge 4: Mattiniero
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Mattiniero",
                     description: "Completa 5 allenamenti prima delle 9:00",
                     imageName: "sunrise.fill",
                     isEarned: false)
            )
            
            // Badge 5: Cardio Pro
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Cardio Pro",
                     description: "Completa 15 allenamenti cardiovascolari",
                     imageName: "heart.fill",
                     isEarned: false)
            )
            
            // Badge 6: Maratoneta
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Maratoneta",
                     description: "Completa un totale di 50 km di corsa",
                     imageName: "figure.run",
                     isEarned: false)
            )
            
            // Badge 7: Flessibilità
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Flessibilità",
                     description: "Completa 8 sessioni di stretching/yoga",
                     imageName: "figure.mind.and.body",
                     isEarned: false)
            )
            
            // Badge 8: Fuoco
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Fuoco",
                     description: "Brucia 5000 calorie totali",
                     imageName: "flame.fill",
                     isEarned: false)
            )
            
            // Badge 9: Notturno
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Notturno",
                     description: "Completa 5 allenamenti dopo le 20:00",
                     imageName: "moon.stars.fill",
                     isEarned: false)
            )
            
            // Badge 10: Campione
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Campione",
                     description: "Completa 30 allenamenti totali",
                     imageName: "trophy.fill",
                     isEarned: false)
            )
            
            // Badge 11: Resistenza
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Resistenza",
                     description: "Completa un allenamento di durata superiore a 60 minuti",
                     imageName: "stopwatch.fill",
                     isEarned: false)
            )
            
            // Badge 12: Precisione
            workoutManager.badges.append(
                Badge(id: UUID().uuidString,
                     name: "Precisione",
                     description: "Esegui correttamente 20 esercizi di precisione",
                     imageName: "scope",
                     isEarned: false)
            )
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(WorkoutManager()) // Assicurati che WorkoutManager sia configurato per il preview
}

