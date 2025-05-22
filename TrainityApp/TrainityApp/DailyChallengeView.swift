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
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                // Header con icona
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color("blk"))
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: "figure.walk")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(Color("wht"))
                    }
                    
                    Text("Daily Challenge")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                }
                .padding(.top, 10)
                
                // Progresso settimanale
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        let weekdays = ["L", "M", "M", "G", "V", "S", "D"]
                        // Calcolo corretto: Lunedì=0, Martedì=1, ..., Domenica=6
                        let todayWeekday = Calendar.current.component(.weekday, from: Date()) // 1=Dom, 2=Lun, ..., 7=Sab
                        let todayIndex = todayWeekday == 1 ? 6 : todayWeekday - 2 // Converte in 0-6 con Lun=0
                        
                        ForEach(0..<7) { day in
                            ZStack {
                                Circle()
                                    .fill(day == todayIndex ? Color("blk") : Color("wht"))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                day == todayIndex ? Color("blk") : Color("blk").opacity(0.3),
                                                lineWidth: day == todayIndex ? 2.5 : 1.5
                                            )
                                    )
                                    .shadow(
                                        color: day == todayIndex ? .black.opacity(0.15) : .black.opacity(0.08),
                                        radius: day == todayIndex ? 4 : 2,
                                        x: 0,
                                        y: day == todayIndex ? 2 : 1
                                    )
                                
                                if workoutManager.dailyChallengeCompleted[day] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(day == todayIndex ? Color("wht") : Color("blk"))
                                } else {
                                    Text(weekdays[day])
                                        .foregroundColor(day == todayIndex ? Color("wht") : Color("blk"))
                                        .font(.system(size: 14, weight: day == todayIndex ? .semibold : .medium))
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(completedDays) / 7 giorni completati")
                            .font(.subheadline)
                            .foregroundColor(Color("blk").opacity(0.7))
                        
                        if completedDays > 0 {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                // Sezione livello con badge migliorato
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Livello attuale")
                            .font(.subheadline)
                            .foregroundColor(Color("blk").opacity(0.7))
                        
                        HStack(spacing: 8) {
                            Text(selectedDifficultyLevel)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                            
                            Circle()
                                .fill(difficultyColor(for: selectedDifficultyLevel))
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    if readyForNextLevel {
                        Button(action: {
                            showingLevelUpTips = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 16))
                                Text("Level Up")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color("wht"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(difficultyColor(for: nextLevel))
                            .cornerRadius(20)
                            .shadow(color: difficultyColor(for: nextLevel).opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Card dell'allenamento odierno
                if let challenge = currentChallenge {
                    VStack(spacing: 0) {
                        // Header della card
                        VStack(spacing: 8) {
                            HStack {
                                Text("Allenamento di oggi")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                
                                Spacer()
                                
                                Text("\(challenge.estimatedTime) min")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(difficultyColor(for: selectedDifficultyLevel))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(difficultyColor(for: selectedDifficultyLevel).opacity(0.15))
                                    .cornerRadius(12)
                            }
                            
                            Text(challenge.description)
                                .font(.subheadline)
                                .foregroundColor(Color("blk").opacity(0.8))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color("wht"))
                        
                        Divider()
                            .background(Color("blk").opacity(0.1))
                        
                        // Lista esercizi
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(challenge.exercises.enumerated()), id: \.element.id) { index, exercise in
                                    HStack(spacing: 12) {
                                        // Numero esercizio
                                        ZStack {
                                            Circle()
                                                .fill(Color("blk").opacity(0.1))
                                                .frame(width: 28, height: 28)
                                            
                                            Text("\(index + 1)")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color("blk"))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exercise.name)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("blk"))
                                            
                                            Text("\(exercise.sets) serie × \(exercise.reps) ripetizioni")
                                                .font(.caption)
                                                .foregroundColor(Color("blk").opacity(0.6))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal)
                                    
                                    if index < challenge.exercises.count - 1 {
                                        Divider()
                                            .background(Color("blk").opacity(0.05))
                                            .padding(.leading, 52)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        .background(Color("wht"))
                    }
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Bottoni di azione
                    HStack(spacing: 15) {
                        Menu {
                            ForEach(["Facile", "Medio", "Difficile"], id: \.self) { level in
                                Button(action: {
                                    changeDifficultyLevel(to: level)
                                }) {
                                    HStack {
                                        Text(level)
                                        if selectedDifficultyLevel == level {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 16))
                                Text("Cambia livello")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color("blk"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color("wht"))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                        }
                        
                        Button(action: {
                            completeCurrentChallenge(challenge)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text("Completa")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color("wht"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color("blk"))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            // Overlay per level up
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
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("blk"))
            }
        )
        .onAppear {
            
            // RESET TEMPORANEO - Rimuovi dopo il test
           //resetAllData()
            //workoutManager.dailyChallengeCompleted[0] = true
            //workoutManager.dailyChallengeCompleted[1] = true
    
            checkForNewDay()
            checkForNewWeek()
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
        // Calcolo corretto del giorno della settimana (stesso del display)
        let todayWeekday = Calendar.current.component(.weekday, from: Date()) // 1=Dom, 2=Lun, ..., 7=Sab
        let todayIndex = todayWeekday == 1 ? 6 : todayWeekday - 2 // Converte in 0-6 con Lun=0
        print("Today index: \(todayIndex)")
        workoutManager.dailyChallengeCompleted[todayIndex] = true
        completedChallengesCount += 1
        lastChallengeDate = Date()
        currentChallengeIndex = (currentChallengeIndex + 1) % 4
        let workout = Workout(
            name: "Sfida Giornaliera - \(selectedDifficultyLevel)",
            exercises: challenge.exercises,
            restTime: getDifficultyRestTime(for: selectedDifficultyLevel)
        )

        workoutManager.completeWorkout(workout)
    }
    
    // FUNZIONE TEMPORANEA DI RESET - Rimuovi dopo il test

    private func resetAllData() {
        // Cancella tutti i UserDefaults
        UserDefaults.standard.removeObject(forKey: "lastWeekStart")
        UserDefaults.standard.removeObject(forKey: "selectedDifficultyLevel")
        UserDefaults.standard.removeObject(forKey: "currentChallengeIndex")
        UserDefaults.standard.removeObject(forKey: "completedChallengesCount")
        UserDefaults.standard.removeObject(forKey: "lastChallengeDate")
        UserDefaults.standard.removeObject(forKey: "WorkoutManagerData")
        do {
            let data = try JSONEncoder().encode(WorkoutManager())
            UserDefaults.standard.set(data, forKey: "WorkoutManagerData")
            print("Dati salvati con successo")
        } catch {
            print("Errore nel salvataggio dei dati: \(error)")
        }
        
        // Reset dell'array dei completamenti
        workoutManager.dailyChallengeCompleted = Array(repeating: false, count: 7)
       

        
        // Reset delle variabili @AppStorage (le forza ai valori di default)
        selectedDifficultyLevel = "Facile"
        currentChallengeIndex = 0
        completedChallengesCount = 0
        lastChallengeDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        print("🔄 RESET COMPLETO ESEGUITO")
    }
    
    // Controlla nuovo giorno
    private func checkForNewDay() {
        let calendar = Calendar.current
        if !calendar.isDate(lastChallengeDate, inSameDayAs: Date()) {
            // Rotazione solo se sfida completata
        }
    }
    
    // Controlla nuova settimana e resetta se necessario
    private func checkForNewWeek() {
        let calendar = Calendar.current
        let today = Date()
        
        // Ottieni l'inizio della settimana corrente (lunedì)
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = weekday == 1 ? 6 : weekday - 2 // Domenica = 6 giorni da lunedì
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else { return }
        guard let startOfWeekNormalized = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startOfWeek) else { return }
        
        // Controlla se è una nuova settimana rispetto all'ultima volta
        if let lastWeekStart = getLastWeekStart() {
            if !calendar.isDate(lastWeekStart, inSameDayAs: startOfWeekNormalized) {
                // Nuova settimana - resetta tutti i completamenti
                workoutManager.dailyChallengeCompleted = Array(repeating: false, count: 7)
                setLastWeekStart(startOfWeekNormalized)
            }
        } else {
            // Prima volta - salva l'inizio della settimana corrente
            setLastWeekStart(startOfWeekNormalized)
        }
    }
    
    // Funzioni helper per salvare/recuperare l'inizio dell'ultima settimana
    private func getLastWeekStart() -> Date? {
        return UserDefaults.standard.object(forKey: "lastWeekStart") as? Date
    }
    
    private func setLastWeekStart(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "lastWeekStart")
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
            return Color("blk")
        case "Medio":
            return Color(red: 0.9, green: 0.6, blue: 0.0)
        case "Difficile":
            return Color(red: 0.8, green: 0.2, blue: 0.2)
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

