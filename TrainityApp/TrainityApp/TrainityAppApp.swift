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
    // Proprietà pubblicate
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
    
    // Nuove proprietà per tracciare il tempo effettivo dell'allenamento
        @Published var currentWorkoutStartTime: Date?
        @Published var isWorkoutActive: Bool = false
    
    // Contatori specifici per i badge
    private var morningWorkoutsCompleted: Int = 0    // Allenamenti mattutini
    private var eveningWorkoutsCompleted: Int = 0    // Allenamenti serali
    private var weekendWorkoutsCompleted: Int = 0    // Allenamenti nei weekend
    private var longWorkoutsCompleted: Int = 0       // Allenamenti lunghi (>30 min)
    private var dailyChallengesCompleted: Int = 0    // Sfide giornaliere completate
    private var differentDaysWithWorkouts: Int = 0   // Diversi giorni con allenamenti
    private var consecutiveDaysStreak: Int = 0       // Giorni consecutivi di allenamento
    

    
    init() {
        // Inizializza tutti i badge (esistenti e nuovi)
        badges = [
            // Badge esistenti
            Badge(id: "first_workout", name: "Principiante", description: "Completa il tuo primo allenamento", imageName: "star.fill"),
            Badge(id: "week_streak", name: "Determinato", description: "Completa 5 allenamenti", imageName: "flame.fill"),
            Badge(id: "muscle_builder", name: "Esperto", description: "Completa 20 allenamenti", imageName: "trophy.fill"),
            Badge(id: "constancy", name: "Costanza", description: "Completa allenamenti per 7 giorni consecutivi", imageName: "figure.walk.motion"),
            Badge(id: "champion", name: "Campione", description: "Completa 30 allenamenti totali", imageName: "trophy.fill"),
            
            // Nuovi badge
            Badge(id: "early_bird", name: "Mattiniero", description: "Completa 5 allenamenti prima delle 9:00", imageName: "sunrise.fill"),
            Badge(id: "night_owl", name: "Nottambulo", description: "Completa 5 allenamenti dopo le 20:00", imageName: "moon.stars.fill"),
            Badge(id: "weekend_warrior", name: "Guerriero del Weekend", description: "Completa 3 allenamenti durante i weekend", imageName: "figure.run"),
            Badge(id: "challenge_master", name: "Maestro delle Sfide", description: "Completa 5 sfide giornaliere", imageName: "checkmark.seal.fill"),
            Badge(id: "variety", name: "Versatilità", description: "Completa allenamenti in 5 giorni diversi della settimana", imageName: "chart.bar.fill"),
            Badge(id: "exercise_master", name: "Maestro degli Esercizi", description: "Completa 100 esercizi totali", imageName: "dumbbell.fill")
        ]
        
        // Inizializza le statistiche in base alla cronologia esistente
        recalculateAllStats()
    }
    
    // Calcola tutte le statistiche in base alla cronologia
    func recalculateAllStats() {
        totalWorkoutsCompleted = workoutHistory.count
        totalWorkoutMinutes = 0
        activeWorkoutDays = 0
        morningWorkoutsCompleted = 0
        eveningWorkoutsCompleted = 0
        weekendWorkoutsCompleted = 0
        longWorkoutsCompleted = 0
        
        // Reset del contatore per gli esercizi totali
        var totalExercisesCompleted = 0
        
        // Set per tenere traccia dei giorni della settimana con allenamenti
        var workoutDays = Set<String>()
        var workoutDaysOfWeek = Set<Int>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        // Calcola la streak e le statistiche
        for record in workoutHistory {
            // Aggiungi durata
            totalWorkoutMinutes += record.duration
            
            // Aggiungi il giorno come attivo
            let dayString = dateFormatter.string(from: record.date)
            workoutDays.insert(dayString)
            
            // Controlla l'ora del giorno per gli allenamenti
            let hour = calendar.component(.hour, from: record.date)
            if hour < 9 {
                morningWorkoutsCompleted += 1
            } else if hour >= 20 {
                eveningWorkoutsCompleted += 1
            }
            
            // Controlla se è weekend
            let weekday = calendar.component(.weekday, from: record.date)
            workoutDaysOfWeek.insert(weekday)
            if weekday == 1 || weekday == 7 { // Domenica o Sabato
                weekendWorkoutsCompleted += 1
            }
            
            // Controlla la durata dell'allenamento
            if record.duration >= 45 {
                longWorkoutsCompleted += 1
            }
            
            // Conta gli esercizi completati
            if record.completed {
                totalExercisesCompleted += record.workout.exercises.count
            }
        }
        
        activeWorkoutDays = workoutDays.count
        differentDaysWithWorkouts = workoutDaysOfWeek.count
        
        // Calcola la streak di giorni consecutivi
        updateStreak()
        
        // Verifica tutti i badge dopo il ricalcolo
        checkAndAwardBadges(totalExercisesCompleted: totalExercisesCompleted)
    }
    
    // Aggiorna la streak di giorni consecutivi
    private func updateStreak() {
        // Implementazione per calcolare streak
        let calendar = Calendar.current
        
        // Ordina la cronologia per data
        let sortedHistory = workoutHistory.sorted { $0.date < $1.date }
        
        // Gestisci i casi speciali dove non ci sono abbastanza allenamenti
        if sortedHistory.isEmpty {
            consecutiveDaysStreak = 0
            weeklyStreak = 0
            return
        }
        
        if sortedHistory.count == 1 {
            consecutiveDaysStreak = 1
            weeklyStreak = 1
            return
        }
        
        // Trova giorni consecutivi
        var currentStreak = 1
        var maxStreak = 1
        
        // Solo ora iteriamo, sapendo che ci sono almeno 2 elementi
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
    
    private func checkAndAwardBadges(totalExercisesCompleted: Int) {
        // Badge esistenti
        if totalWorkoutsCompleted >= 1 {
            awardBadge(withId: "first_workout")
        }
        
        if totalWorkoutsCompleted >= 5 {
            awardBadge(withId: "week_streak")
        }
        
        if totalWorkoutsCompleted >= 20 {
            awardBadge(withId: "muscle_builder")
        }
        
        if consecutiveDaysStreak >= 7 {
            awardBadge(withId: "constancy")
        }
        
        if totalWorkoutsCompleted >= 30 {
            awardBadge(withId: "champion")
        }
        
        // Nuovi badge
        if morningWorkoutsCompleted >= 5 {
            awardBadge(withId: "early_bird")
        }
        
        if eveningWorkoutsCompleted >= 5 {
            awardBadge(withId: "night_owl")
        }
        
        if weekendWorkoutsCompleted >= 3 {
            awardBadge(withId: "weekend_warrior")
        }
        
        if longWorkoutsCompleted >= 1 {
            awardBadge(withId: "marathon")
        }
        
        if dailyChallengesCompleted >= 5 {
            awardBadge(withId: "challenge_master")
        }
        
        if differentDaysWithWorkouts >= 5 {
            awardBadge(withId: "variety")
        }
        
        // Badge per ore totali di allenamento (10 ore = 600 minuti)
        if totalWorkoutMinutes >= 600 {
            awardBadge(withId: "dedication")
        }
        
        // Badge per esercizi totali completati
        if totalExercisesCompleted >= 100 {
            awardBadge(withId: "exercise_master")
        }
    }
    
    // Funzione per tracciare il completamento delle sfide giornaliere
    func completeDailyChallenge() {
        dailyChallengesCompleted += 1
        checkAndAwardBadges(totalExercisesCompleted: 0) // Controlla solo per il badge challenge_master
    }
    
    // Funzione per completare un allenamento
    func completeWorkout(_ workout: Workout) {
        // Aggiunge il workout alla cronologia
        let record = WorkoutRecord(
            workout: workout,
            date: Date(),
            duration: workout.duration,
            completed: true,
            caloriesBurned: 0 // Non calcoliamo calorie per evitare imprecisioni
        )
        
        workoutHistory.append(record)
        
        // Aggiorna tutte le statistiche
        recalculateAllStats()
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
