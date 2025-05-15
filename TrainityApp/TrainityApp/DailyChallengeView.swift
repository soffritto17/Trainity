import SwiftUI

struct DailyChallengeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
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
                        Exercise(name: "Jumping Jacks", sets: 3, reps: 12),
                        Exercise(name: "Squats", sets: 2, reps: 10),
                        Exercise(name: "Push Ups", sets: 2, reps: 8)
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
            Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
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
                
                // Sezione del calendario settimanale
                VStack(spacing: 8) {
                    HStack(spacing: 15) {
                        ForEach(0..<7) { day in
                            let weekdays = ["L", "M", "M", "G", "V", "S", "D"]
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
                    
                    Text("\(completedDays) / 7 Completati")
                        .font(.headline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
                
                // Sezione del livello attuale
                VStack(spacing: 10) {
                    HStack {
                        Text("Livello attuale:")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
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
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Mostra i dettagli della sfida corrente
                    if let challenge = currentChallenge {
                        // Sfide completate sul totale
                        Text("Sfide completate: \(completedChallengesCount)")
                            .font(.subheadline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
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
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: difficultyIcon(for: selectedDifficultyLevel))
                                        .font(.system(size: 30))
                                        .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                                }
                                .padding(.horizontal)
                                
                                Text(challenge.description)
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .padding(.horizontal)
                                
                                Text("Esercizi:")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .padding(.horizontal)
                                    .padding(.top, 5)
                                
                                ForEach(challenge.exercises) { exercise in
                                    HStack {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 8))
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                        
                                        Text(exercise.name)
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                        
                                        Spacer()
                                        
                                        Text("\(exercise.sets) × \(exercise.reps)")
                                            .font(.body)
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    }
                                    .padding(.vertical, 5)
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                        .background(Color(red: 0.75, green: 0.95, blue: 0.95))
                        .cornerRadius(10)
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
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.8, green: 0.95, blue: 0.95))
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                completeCurrentChallenge(challenge)
                            }) {
                                Text("Completa")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                
                Spacer()
            }
            
            // Sheet per i consigli sul passaggio di livello
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
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(difficultyColor(for: nextLevel))
                    
                    Text("Hai completato \(completedChallengesCount) sfide di livello \(selectedDifficultyLevel). Il tuo corpo e la tua mente si sono adattati e ora puoi passare al livello \(nextLevel)!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Cosa ti aspetta nel livello \(nextLevel):")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
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
                    .background(Color(red: 0.75, green: 0.95, blue: 0.95))
                    .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingLevelUpTips = false
                        }) {
                            Text("Non ancora")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.8, green: 0.95, blue: 0.95))
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            changeDifficultyLevel(to: nextLevel)
                            showingLevelUpTips = false
                        }) {
                            Text("Cambia livello")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(difficultyColor(for: nextLevel))
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal, 30)
                .transition(.scale)
            }
        }
        .navigationTitle("Daily Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            checkForNewDay()
        }
    }
    
    // Funzioni di supporto
    
    // Cambia il livello di difficoltà
    private func changeDifficultyLevel(to level: String) {
        selectedDifficultyLevel = level
        if level != "Facile" {
            // Resetta il contatore delle sfide completate quando cambi livello
            completedChallengesCount = 0
        }
    }
    
    // Completa la sfida corrente
    private func completeCurrentChallenge(_ challenge: DailyChallenge) {
        // Segna la sfida come completata
        let today = Calendar.current.component(.weekday, from: Date()) - 1
        workoutManager.dailyChallengeCompleted[today % 7] = true
        
        // Aggiorna il conteggio delle sfide completate
        completedChallengesCount += 1
        
        // Imposta la data dell'ultima sfida completata
        lastChallengeDate = Date()
        
        // Passa alla prossima sfida nella rotazione
        currentChallengeIndex = (currentChallengeIndex + 1) % 4
        
        // Salva come allenamento completato
        let workout = Workout(
            name: "Sfida Giornaliera - \(selectedDifficultyLevel) #\((currentChallengeIndex % 4) + 1)",
            duration: challenge.estimatedTime,
            exercises: challenge.exercises,
            goal: "Daily Challenge",
            restTime: getDifficultyRestTime(for: selectedDifficultyLevel)
        )
        workoutManager.completeWorkout(workout)
    }
    
    // Verifica se è un nuovo giorno e aggiorna la sfida se necessario
    private func checkForNewDay() {
        let calendar = Calendar.current
        if !calendar.isDate(lastChallengeDate, inSameDayAs: Date()) {
            // È un nuovo giorno, potremmo cambiare la sfida
            // La rotazione avviene solo quando l'utente completa una sfida
        }
    }
    
    // Ottieni il tempo di riposo basato sulla difficoltà
    private func getDifficultyRestTime(for difficulty: String) -> Int {
        switch difficulty {
        case "Facile": return 30
        case "Medio": return 20
        case "Difficile": return 15
        default: return 30
        }
    }
    
    // Funzione per determinare il colore in base alla difficoltà
    private func difficultyColor(for difficulty: String) -> Color {
        switch difficulty {
        case "Facile":
            return Color(red: 0.0, green: 0.6, blue: 0.3)
        case "Medio":
            return Color(red: 0.9, green: 0.6, blue: 0.0)
        case "Difficile":
            return Color(red: 0.8, green: 0.2, blue: 0.2)
        default:
            return Color.gray
        }
    }
    
    // Funzione per determinare l'icona in base alla difficoltà
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
        DailyChallengeView()
            .environmentObject(WorkoutManager())
    }
}
