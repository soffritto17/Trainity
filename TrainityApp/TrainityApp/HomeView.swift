//
//  HomeView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    // Proprietà per le frasi motivazionali
    let motivationalQuotes = [
        "Il fitness è come una relazione. Devi rimanerci fedele perché funzioni.",
        "La forza non viene da ciò che puoi fare. Viene dal superare ciò che pensavi di non poter fare.",
        "Ci vuole un po' più di forza per fare un altro passo in avanti.",
        "Il cambiamento avviene quando l'impegno supera la resistenza.",
        "Il miglior progetto su cui puoi lavorare sei tu stesso.",
        "Più sudi in allenamento, meno sanguini in battaglia.",
        "Credi in te stesso e sarai inarrestabile.",
        "La fatica dura un'ora. L'orgoglio dura per sempre.",
        "Nessun dolore, nessun guadagno. Nessun sforzo, nessun risultato.",
        "La costanza è più importante della perfezione.",
        "Il tuo corpo può sopportare quasi tutto. È la tua mente che devi convincere.",
        "Investi in te stesso. È il miglior investimento che farai mai.",
        "Non aspettare. Il momento non sarà mai perfetto.",
        "Gli ostacoli sono quelle cose spaventose che vedi quando togli gli occhi dal tuo obiettivo.",
        "Rendi il tuo corpo l'arma più forte, non la tua debolezza."
    ]
    
    // Proprietà per ottenere la frase del giorno
    var todaysQuote: String {
        let today = Calendar.current.component(.day, from: Date())
        return motivationalQuotes[today % motivationalQuotes.count]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    // Sezione verde in alto più piccola senza il testo TRAINITY
                    Rectangle()
                        .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .frame(height: 0)
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Resto del contenuto inizia un po' più in alto
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
                    
                    // Progress overview
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
                    
                    // Sezione per la frase motivazionale
                    VStack(alignment: .center, spacing: 10) {
                        Text("💪 Daily Motivation")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        Text(todaysQuote)
                            .font(.body)
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
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

