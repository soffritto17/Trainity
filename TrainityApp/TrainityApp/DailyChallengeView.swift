import SwiftUI

struct DailyChallengeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingChallengeDetails = false
    @State private var showingLevelUpTips = false
    
    // Nuove variabili di stato
    @AppStorage("selectedDifficultyLevel") private var selectedDifficultyLevel: String = "Facile"
    @AppStorage("currentChallengeIndex") private var currentChallengeIndex: Int = 0
    @AppStorage("completedChallengesCount") private var completedChallengesCount: Int = 0
    @AppStorage("lastChallengeDate") private var lastChallengeDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    // Calcola quanti giorni sono stati completati nella settimana corrente
    private var completedDays: Int {
        workoutManager.dailyChallengeCompleted.filter { $0 }.count
    }
    
    // Genera quattro allenamenti diversi per ogni livello di difficoltà
    private var challenges: [String: [DailyChallenge]] {
        [
            "Facile": [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Wall Push-ups", sets: 2, reps: 8),
                        Exercise(name: "Squats", sets: 2, reps: 8),
                        Exercise(name: "Push Ups", sets: 2, reps: 6)
                    ],
                    difficulty: "Facile",
                    description: "Un allenamento leggero per iniziare la giornata con energia!",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "High Knees", sets: 2, reps: 20),
                        Exercise(name: "Glute Bridges", sets: 3, reps: 12),
                        Exercise(name: "Plank", sets: 2, reps: 20) // secondi
                    ],
                    difficulty: "Facile",
                    description: "Un allenamento semplice per migliorare la resistenza di base.",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Arm Circles", sets: 2, reps: 15),
                        Exercise(name: "Walking Lunges", sets: 2, reps: 10),
                        Exercise(name: "Wall Sit", sets: 2, reps: 20) // secondi
                    ],
                    difficulty: "Facile",
                    description: "Concentrati sulla forma corretta per massimizzare i benefici.",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Side Lunges", sets: 2, reps: 8),
                        Exercise(name: "Seated Leg Raises", sets: 3, reps: 10),
                        Exercise(name: "Modified Push Ups", sets: 2, reps: 8)
                    ],
                    difficulty: "Facile",
                    description: "Un allenamento completo del corpo a bassa intensità.",
                    estimatedTime: 15
                )
            ],
            "Medio": [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Burpees", sets: 3, reps: 10),
                        Exercise(name: "Lunges", sets: 3, reps: 12),
                        Exercise(name: "Mountain Climbers", sets: 3, reps: 20),
                        Exercise(name: "Plank", sets: 3, reps: 30) // secondi
                    ],
                    difficulty: "Medio",
                    description: "Un allenamento di media intensità per migliorare forza e resistenza.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Jump Squats", sets: 3, reps: 15),
                        Exercise(name: "Push Up with Rotation", sets: 3, reps: 8),
                        Exercise(name: "Bicycle Crunches", sets: 3, reps: 20),
                        Exercise(name: "Russian Twists", sets: 3, reps: 15)
                    ],
                    difficulty: "Medio",
                    description: "Lavora sul core e sulla forza del tronco in questa sfida.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Lateral Shuffle", sets: 3, reps: 20),
                        Exercise(name: "Walking Planks", sets: 3, reps: 10),
                        Exercise(name: "Curtsy Lunges", sets: 3, reps: 12),
                        Exercise(name: "Tricep Dips", sets: 3, reps: 12)
                    ],
                    difficulty: "Medio",
                    description: "Migliora la mobilità e la forza con questo circuito.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Side Plank", sets: 3, reps: 20), // secondi per lato
                        Exercise(name: "Donkey Kicks", sets: 3, reps: 15),
                        Exercise(name: "Shoulder Taps", sets: 3, reps: 16),
                        Exercise(name: "Flutter Kicks", sets: 3, reps: 30)
                    ],
                    difficulty: "Medio",
                    description: "Concentrati sulla stabilizzazione e sul core con questo workout.",
                    estimatedTime: 25
                )
            ],
            "Difficile": [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Burpees", sets: 4, reps: 15),
                        Exercise(name: "Jump Squats", sets: 4, reps: 20),
                        Exercise(name: "Push Up with Rotation", sets: 4, reps: 12),
                        Exercise(name: "Mountain Climbers", sets: 4, reps: 30),
                        Exercise(name: "Plank with Shoulder Tap", sets: 3, reps: 40) // secondi
                    ],
                    difficulty: "Difficile",
                    description: "Una sfida intensa per atleti esperti!",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Jumping Lunges", sets: 4, reps: 20),
                        Exercise(name: "Burpee Push-ups", sets: 3, reps: 12),
                        Exercise(name: "Plank Jacks", sets: 4, reps: 25),
                        Exercise(name: "V-Ups", sets: 4, reps: 15),
                        Exercise(name: "Alternating Superman", sets: 3, reps: 20)
                    ],
                    difficulty: "Difficile",
                    description: "Un allenamento ad alta intensità per massimizzare il condizionamento.",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Diamond Push-ups", sets: 3, reps: 15),
                        Exercise(name: "Pistol Squats", sets: 3, reps: 8),
                        Exercise(name: "Tuck Jumps", sets: 4, reps: 15),
                        Exercise(name: "Dragon Flags", sets: 3, reps: 10),
                        Exercise(name: "Hollow Body Holds", sets: 3, reps: 45) // secondi
                    ],
                    difficulty: "Difficile",
                    description: "Questa sfida metterà alla prova la tua forza e resistenza.",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Handstand Push-ups", sets: 3, reps: 8),
                        Exercise(name: "Box Jumps", sets: 4, reps: 15),
                        Exercise(name: "Wide Push-ups", sets: 4, reps: 15),
                        Exercise(name: "Single Leg Burpees", sets: 3, reps: 10),
                        Exercise(name: "L-Sit Hold", sets: 3, reps: 30) // secondi
                    ],
                    difficulty: "Difficile",
                    description: "Un allenamento avanzato che richiede forza e controllo del corpo.",
                    estimatedTime: 35
                )
            ]
        ]
    }
    
    // Ottieni la sfida corrente
    private var currentChallenge: DailyChallenge? {
        guard let challengesForLevel = challenges[selectedDifficultyLevel] else { return nil }
        return challengesForLevel[currentChallengeIndex % challengesForLevel.count]
    }
    
    // Verifica se l'utente è pronto per avanzare di livello
    private var readyForNextLevel: Bool {
        if selectedDifficultyLevel == "Difficile" { return false }
        return completedChallengesCount >= 8
    }
    
    // Determina il prossimo livello di difficoltà
    private var nextLevel: String {
        switch selectedDifficultyLevel {
        case "Facile": return "Medio"
        case "Medio": return "Difficile"
        default: return selectedDifficultyLevel
        }
    }
    
    var body: some View {
        ZStack {
            // Colore di sfondo più chiaro come nello screenshot
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Icona del manubrio
                ZStack {
                    Circle()
                        .fill(Color("blk"))
                        .frame(width: 80, height: 80)
                        .shadow(radius: 3)
                    
                    Image(systemName: "figure.walk")  // icona più pertinente daily habits
                        .font(.system(size: 36))
                        .foregroundColor(Color("wht"))
                }
                .padding(.top, 20)
                
                // Sezione del calendario settimanale
                VStack(spacing: 8) {
                    HStack(spacing: 15) {
                        let weekdays = ["L", "M", "M", "G", "V", "S", "D"]
                        ForEach(0..<7) { day in
                            ZStack {
                                Circle()
                                    .fill(workoutManager.dailyChallengeCompleted[day] ? Color("blk") : Color("wht"))
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color("blk"), lineWidth: 2)
                                    )
                                    .shadow(radius: 1)
                                
                                Text(weekdays[day])
                                    .foregroundColor(workoutManager.dailyChallengeCompleted[day] ? Color("wht") : Color("blk"))
                                    .font(.headline)
                            }
                        }
                    }
                    
                    Text("\(completedDays) / 7 Completati")
                        .font(.headline)
                        .foregroundColor(Color("blk"))
                }
                
                // Sezione del livello attuale
                VStack(spacing: 10) {
                    HStack {
                        Text("Livello attuale:")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        Text(selectedDifficultyLevel)
                            .font(.headline)
                            .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(difficultyColor(for: selectedDifficultyLevel).opacity(0.2))
                            )
                        
                        Spacer()
                        
                        if readyForNextLevel {
                            Button(action: {
                                showingLevelUpTips = true
                            }) {
                                Label("Consigli", systemImage: "info.circle")
                                    .font(.subheadline)
                                    .foregroundColor(Color("wht"))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color("blk"))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Mostra i dettagli della sfida corrente
                    if let challenge = currentChallenge {
                        Text("Sfide completate: \(completedChallengesCount)")
                            .font(.subheadline)
                            .foregroundColor(Color("blk"))
                            .padding(.bottom, 5)
                        
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Sfida \((currentChallengeIndex % 4) + 1)/4")
                                            .font(.headline)
                                            .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                                        
                                        Text("Tempo stimato: \(challenge.estimatedTime) min")
                                            .font(.subheadline)
                                            .foregroundColor(Color("blk"))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: difficultyIcon(for: selectedDifficultyLevel))
                                        .font(.system(size: 30))
                                        .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                                }
                                .padding(.horizontal)
                                
                                Text(challenge.description)
                                    .font(.subheadline)
                                    .foregroundColor(Color("blk"))
                                    .padding(.horizontal)
                                
                                Text("Esercizi:")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                                
                                ForEach(challenge.exercises) { exercise in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(Color("blk"))
                                        
                                        Text(exercise.name)
                                            .font(.body)
                                            .foregroundColor(Color("blk"))
                                        
                                        Spacer()
                                        
                                        Text("\(exercise.sets) × \(exercise.reps)")
                                            .font(.body)
                                            .foregroundColor(Color("blk"))
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                        .background(Color("wht"))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Menu {
                                ForEach(["Facile", "Medio", "Difficile"], id: \.self) { level in
                                    Button(action: {
                                        changeDifficultyLevel(to: level)
                                    }) {
                                        Text(level)
                                        if selectedDifficultyLevel == level {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            } label: {
                                Text("Livello")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("wht"))
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                            }
                            
                            Button(action: {
                                completeCurrentChallenge(challenge)
                            }) {
                                Text("Completa")
                                    .font(.headline)
                                    .foregroundColor(Color("wht"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("blk"))
                                    .cornerRadius(10)
                                    .shadow(radius: 1)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                
                Spacer()
            }
            
            if showingLevelUpTips {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingLevelUpTips = false
                    }
                
                VStack(spacing: 20) {
                    Text("Sei pronto per il prossimo livello!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(difficultyColor(for: nextLevel))
                    
                    Text("Hai completato \(completedChallengesCount) sfide di livello \(selectedDifficultyLevel). Il tuo corpo e la tua mente si sono adattati e ora puoi passare al livello \(nextLevel)!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("blk"))
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cosa ti aspetta nel livello \(nextLevel):")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(difficultyColor(for: nextLevel))
                            Text("Intensità maggiore")
                        }
                        
                        HStack {
                            Image(systemName: "stopwatch.fill")
                                .foregroundColor(difficultyColor(for: nextLevel))
                            Text("Allenamenti più lunghi")
                        }
                        
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(difficultyColor(for: nextLevel))
                            Text("Più esercizi per sessione")
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingLevelUpTips = false
                        }) {
                            Text("Non ancora")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("wht"))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                        }
                        
                        Button(action: {
                            changeDifficultyLevel(to: nextLevel)
                            showingLevelUpTips = false
                        }) {
                            Text("Cambia livello")
                                .font(.headline)
                                .foregroundColor(Color("wht"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(difficultyColor(for: nextLevel))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                        }
                    }
                }
                .padding()
                .background(Color("wht"))
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal, 30)
                .transition(.scale)
            }
        }
        .navigationTitle("Daily Challenge")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("blk"))
            }
        )
        .onAppear {
            checkForNewDay()
        }
    }
    
    // Cambia il livello di difficoltà
    private func changeDifficultyLevel(to level: String) {
        selectedDifficultyLevel = level
        if level != "Facile" {
            completedChallengesCount = 0
        }
    }
    
    // Completa la sfida corrente
    private func completeCurrentChallenge(_ challenge: DailyChallenge) {
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        workoutManager.dailyChallengeCompleted[today % 7] = true
        completedChallengesCount += 1
        lastChallengeDate = Date()
        currentChallengeIndex = (currentChallengeIndex + 1) % 4
        let workout = Workout(
            name: "Sfida Giornaliera - \(selectedDifficultyLevel) #\((currentChallengeIndex % 4) + 1)",
            duration: challenge.estimatedTime,
            exercises: challenge.exercises,
            goal: "Daily Challenge",
            restTime: getDifficultyRestTime(for: selectedDifficultyLevel)
        )
        workoutManager.completeWorkout(workout)
    }
    
    // Controlla nuovo giorno
    private func checkForNewDay() {
        let calendar = Calendar.current
        if !calendar.isDate(lastChallengeDate, inSameDayAs: Date()) {
            // Rotazione solo se sfida completata
        }
    }
    
    // Tempi di riposo per livello
    private func getDifficultyRestTime(for difficulty: String) -> Int {
        switch difficulty {
        case "Facile": return 30
        case "Medio": return 20
        case "Difficile": return 15
        default: return 30
        }
    }
    
    // Colori per livello
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "Facile":
            return Color("blk") // Verde scuro
        case "Medio":
            return Color(red: 0.9, green: 0.6, blue: 0.0) // Arancio
        case "Difficile":
            return Color(red: 0.8, green: 0.2, blue: 0.2) // Rosso scuro
        default:
            return Color.gray
        }
    }
    
    // Icone per livello
    private func difficultyIcon(for difficulty: String) -> String {
        switch difficulty {
        case "Facile":
            return "1.circle.fill"
        case "Medio":
            return "2.circle.fill"
        case "Difficile":
            return "3.circle.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DailyChallengeView()
                .environmentObject(WorkoutManager())
        }
    }
}
