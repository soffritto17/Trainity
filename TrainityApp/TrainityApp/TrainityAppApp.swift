import SwiftUI

@main
struct TrainityApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MODELLI DI DATI
struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var isCompleted: Bool = false
}

struct DailyChallenge {
    var exercises: [Exercise]
    var difficulty: String
    var description: String
    var estimatedTime: Int // in minuti
}

struct Workout: Identifiable {
    var id = UUID()
    var name: String
    var duration: Int // in minuti
    var exercises: [Exercise]
    var goal: String
    var restTime: Int // in secondi
    
}

struct WorkoutRecord: Identifiable {
    var id = UUID()
    var workout: Workout
    var date: Date
    var duration: Int
    var completed: Bool
    var caloriesBurned: Int = 0
}

struct Badge: Identifiable {
    var id: String
    var name: String
    var description: String
    var imageName: String
    var isEarned: Bool = false
}

class WorkoutManager: ObservableObject {
    @Published var dailyChallengeCompleted = [false, false, false, false, false, false, false]
    @Published var savedWorkouts: [Workout] = []
    @Published var workoutHistory: [WorkoutRecord] = []
    @Published var nickname: String = "Atleta"
    @Published var totalWorkoutsCompleted: Int = 0
    @Published var weeklyStreak: Int = 1
    @Published var badgesEarned: Int = 0
    @Published var badges: [Badge] = []
    
    // Proprietà per tracciare le statistiche per i badge
    @Published var totalCaloriesBurned: Int = 0
    @Published var totalWorkoutMinutes: Int = 0
    @Published var activeWorkoutDays: Int = 0
    
    // Contatori specifici per i badge
    private var strengthWorkoutsCompleted: Int = 0
    private var cardioWorkoutsCompleted: Int = 0
    private var flexibilityWorkoutsCompleted: Int = 0
    private var runningDistanceKm: Int = 0
    private var morningWorkoutsCompleted: Int = 0
    private var eveningWorkoutsCompleted: Int = 0
    private var precisionExercisesCompleted: Int = 0
    private var consecutiveDaysStreak: Int = 0
    private var longestWorkoutDuration: Int = 0
    
    
    init() {
        
        // Inizializza tutti i badge (esistenti e nuovi)
        badges = [
            // Badge esistenti
            Badge(id: "first_workout", name: "Principiante", description: "Completa il tuo primo allenamento", imageName: "star.fill"),
            Badge(id: "week_streak", name: "Determinato", description: "Completa 5 allenamenti", imageName: "flame.fill"),
            Badge(id: "muscle_builder", name: "Esperto", description: "Completa 20 allenamenti", imageName: "trophy.fill"),
            
            // Nuovi badge
            Badge(id: "constancy", name: "Costanza", description: "Completa allenamenti per 7 giorni consecutivi", imageName: "figure.walk.motion"),
            Badge(id: "champion", name: "Campione", description: "Completa 30 allenamenti totali", imageName: "trophy.fill"),
        ]
        
        // Inizializza le statistiche in base alla cronologia esistente
        recalculateAllStats()
    }
    
    // Calcola tutte le statistiche in base alla cronologia
    func recalculateAllStats() {
        totalWorkoutsCompleted = workoutHistory.count
        totalCaloriesBurned = 0
        totalWorkoutMinutes = 0
        activeWorkoutDays = 0
        eveningWorkoutsCompleted = 0
        
        // Set per tenere traccia dei giorni di allenamento
        var workoutDays = Set<String>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Calcola la streak e le statistiche
        for record in workoutHistory {
            // Aggiungi calorie e durata
            totalCaloriesBurned += record.caloriesBurned
            totalWorkoutMinutes += record.duration
            
            // Aggiungi il giorno come attivo
            let dayString = dateFormatter.string(from: record.date)
            workoutDays.insert(dayString)
            
            
            // Aggiorna la durata più lunga
            if record.duration > longestWorkoutDuration {
                longestWorkoutDuration = record.duration
            }
        }
        
        activeWorkoutDays = workoutDays.count
        
        // Verifica tutti i badge dopo la ricalcolo
        checkAndAwardBadges()
    }
    
    func completeWorkout(_ workout: Workout) {
        // Aggiunge il workout alla cronologia
        let record = WorkoutRecord(
            workout: workout,
            date: Date(),
            duration: workout.duration,
            completed: true,
        )
        
        //workoutHistory.append(record)
        
        // Aggiorna tutte le statistiche
        recalculateAllStats()
    }
    
    
    private func updateStreak() {
        // Implementazione più completa per calcolare streak
        let calendar = Calendar.current
        
        // Ordina la cronologia per data
        let sortedHistory = workoutHistory.sorted { $0.date < $1.date }
        
        // Trova giorni consecutivi
        var currentStreak = 1
        var maxStreak = 1
        
        for i in 1..<sortedHistory.count {
            let currentDate = calendar.startOfDay(for: sortedHistory[i].date)
            let previousDate = calendar.startOfDay(for: sortedHistory[i-1].date)
            
            // Calcola giorni di differenza
            if let days = calendar.dateComponents([.day], from: previousDate, to: currentDate).day {
                if days == 1 {
                    // Giorno consecutivo
                    currentStreak += 1
                } else if days > 1 {
                    // Streak interrotto
                    if currentStreak > maxStreak {
                        maxStreak = currentStreak
                    }
                    currentStreak = 1
                }
            }
        }
        
        // Aggiorna il massimo se necessario
        if currentStreak > maxStreak {
            maxStreak = currentStreak
        }
        
        consecutiveDaysStreak = maxStreak
        weeklyStreak = maxStreak // Per compatibilità
    }
    
    private func checkAndAwardBadges() {
        // Badge "Principiante" - Primo allenamento
        if totalWorkoutsCompleted >= 1 {
            awardBadge(withId: "first_workout")
        }
        
        // Badge "Determinato" - 5 allenamenti
        if totalWorkoutsCompleted >= 5 {
            awardBadge(withId: "week_streak")
        }
        
        // Badge "Esperto" - 20 allenamenti
        if totalWorkoutsCompleted >= 20 {
            awardBadge(withId: "muscle_builder")
        }
        
        // Badge "Costanza" - 7 giorni consecutivi
        if consecutiveDaysStreak >= 7 {
            awardBadge(withId: "constancy")
        }
        
        // Badge "Campione" - 30 allenamenti totali
        if totalWorkoutsCompleted >= 30 {
            awardBadge(withId: "champion")
        }
    }
    
    // Funzione di utilità per assegnare un badge specifico
    private func awardBadge(withId id: String) {
        if let index = badges.firstIndex(where: { $0.id == id && !$0.isEarned }) {
            badges[index].isEarned = true
            badgesEarned += 1
            
            // Qui potresti aggiungere codice per notifiche/animazioni
            print("Badge guadagnato: \(badges[index].name)")
        }
    }
}
