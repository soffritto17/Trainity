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
struct Exercise: Identifiable {
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
    var type: WorkoutType = .general // Tipo di allenamento
    var caloriesBurned: Int = 0 // Calorie bruciate stimate
}

// Tipi di allenamento per tracciare i badge specifici
enum WorkoutType {
    case general
    case strength
    case cardio
    case flexibility
    case running
    case hiit
}

struct Question {
    let text: String
    let options: [String]
    let bodyPart: String
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
    private var uniqueWorkoutTypesCompleted: Set<WorkoutType> = []
    private var precisionExercisesCompleted: Int = 0
    private var consecutiveDaysStreak: Int = 0
    private var longestWorkoutDuration: Int = 0
    
    // Esempio di allenamento per "Build Muscle"
    let buildMuscleWorkout = Workout(
        name: "Build Muscle",
        duration: 30,
        exercises: [
            Exercise(name: "Bench Press", sets: 3, reps: 6),
            Exercise(name: "Lat Pulldown", sets: 3, reps: 8),
            Exercise(name: "Dumbbell Curl", sets: 3, reps: 8),
            Exercise(name: "Tricep Dip", sets: 3, reps: 10)
        ],
        goal: "Build Muscle",
        restTime: 30,
        type: .strength,
        caloriesBurned: 250
    )
    
    // Esempio di allenamento per "Weight Loss"
    let weightLossWorkout = Workout(
        name: "Weight Loss",
        duration: 40,
        exercises: [
            Exercise(name: "Jumping Jacks", sets: 3, reps: 20),
            Exercise(name: "Mountain Climbers", sets: 3, reps: 15),
            Exercise(name: "Burpees", sets: 3, reps: 10),
            Exercise(name: "High Knees", sets: 3, reps: 30)
        ],
        goal: "Weight Loss",
        restTime: 20,
        type: .cardio,
        caloriesBurned: 350
    )
    
    init() {
        savedWorkouts.append(buildMuscleWorkout)
        savedWorkouts.append(weightLossWorkout)
        
        // Inizializza tutti i badge (esistenti e nuovi)
        badges = [
            // Badge esistenti
            Badge(id: "first_workout", name: "Principiante", description: "Completa il tuo primo allenamento", imageName: "star.fill"),
            Badge(id: "week_streak", name: "Determinato", description: "Completa 5 allenamenti", imageName: "flame.fill"),
            Badge(id: "muscle_builder", name: "Esperto", description: "Completa 20 allenamenti", imageName: "trophy.fill"),
            
            // Nuovi badge
            Badge(id: "constancy", name: "Costanza", description: "Completa allenamenti per 7 giorni consecutivi", imageName: "figure.walk.motion"),
            Badge(id: "strength", name: "Forza", description: "Completa 10 allenamenti di forza", imageName: "dumbbell.fill"),
            Badge(id: "explorer", name: "Esploratore", description: "Prova 5 tipi diversi di allenamento", imageName: "figure.hiking"),
            Badge(id: "morning", name: "Mattiniero", description: "Completa 5 allenamenti prima delle 9:00", imageName: "sunrise.fill"),
            Badge(id: "cardio_pro", name: "Cardio Pro", description: "Completa 15 allenamenti cardiovascolari", imageName: "heart.fill"),
            Badge(id: "marathoner", name: "Maratoneta", description: "Completa un totale di 50 km di corsa", imageName: "figure.run"),
            Badge(id: "flexibility", name: "Flessibilità", description: "Completa 8 sessioni di stretching/yoga", imageName: "figure.mind.and.body"),
            Badge(id: "fire", name: "Fuoco", description: "Brucia 5000 calorie totali", imageName: "flame.fill"),
            Badge(id: "night_owl", name: "Notturno", description: "Completa 5 allenamenti dopo le 20:00", imageName: "moon.stars.fill"),
            Badge(id: "champion", name: "Campione", description: "Completa 30 allenamenti totali", imageName: "trophy.fill"),
            Badge(id: "endurance", name: "Resistenza", description: "Completa un allenamento di durata superiore a 60 minuti", imageName: "stopwatch.fill"),
            Badge(id: "precision", name: "Precisione", description: "Esegui correttamente 20 esercizi di precisione", imageName: "scope")
        ]
        
        // Esempio di storico allenamenti
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        workoutHistory = [
            WorkoutRecord(
                workout: buildMuscleWorkout,
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                duration: 32,
                completed: true,
                caloriesBurned: 260
            ),
            WorkoutRecord(
                workout: weightLossWorkout,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                duration: 38,
                completed: true,
                caloriesBurned: 340
            )
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
        strengthWorkoutsCompleted = 0
        cardioWorkoutsCompleted = 0
        flexibilityWorkoutsCompleted = 0
        runningDistanceKm = 0
        morningWorkoutsCompleted = 0
        eveningWorkoutsCompleted = 0
        uniqueWorkoutTypesCompleted = []
        
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
            
            // Aggiorna statistiche per tipo
            if record.workout.type == .strength {
                strengthWorkoutsCompleted += 1
            } else if record.workout.type == .cardio {
                cardioWorkoutsCompleted += 1
            } else if record.workout.type == .flexibility {
                flexibilityWorkoutsCompleted += 1
            } else if record.workout.type == .running {
                // Approssimazione: un allenamento di corsa aggiunge 5km
                runningDistanceKm += 5
            }
            
            // Aggiorna statistiche per ora del giorno
            let hour = Calendar.current.component(.hour, from: record.date)
            if hour < 9 {
                morningWorkoutsCompleted += 1
            } else if hour >= 20 {
                eveningWorkoutsCompleted += 1
            }
            
            // Aggiungi il tipo di allenamento a quelli completati
            uniqueWorkoutTypesCompleted.insert(record.workout.type)
            
            // Aggiorna la durata più lunga
            if record.duration > longestWorkoutDuration {
                longestWorkoutDuration = record.duration
            }
        }
        
        activeWorkoutDays = workoutDays.count
        
        // Verifica tutti i badge dopo la ricalcolo
        checkAndAwardBadges()
    }
    
    func generateWorkout(duration: Int, exerciseCount: Int, goal: String, restTime: Int) -> Workout {
        // Qui implementeresti la logica per generare un allenamento personalizzato
        if goal == "Weight Loss" {
            return weightLossWorkout
        } else {
            return buildMuscleWorkout
        }
    }
    
    func completeWorkout(_ workout: Workout) {
        // Aggiunge il workout alla cronologia
        let record = WorkoutRecord(
            workout: workout,
            date: Date(),
            duration: workout.duration,
            completed: true,
            caloriesBurned: workout.caloriesBurned
        )
        
        workoutHistory.append(record)
        
        // Aggiorna tutte le statistiche
        recalculateAllStats()
    }
    
    func completePrecisionExercise() {
        // Chiamare quando un utente completa correttamente un esercizio di precisione
        precisionExercisesCompleted += 1
        checkAndAwardBadges()
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
        
        // Badge "Forza" - 10 allenamenti di forza
        if strengthWorkoutsCompleted >= 10 {
            awardBadge(withId: "strength")
        }
        
        // Badge "Esploratore" - 5 tipi diversi di allenamento
        if uniqueWorkoutTypesCompleted.count >= 5 {
            awardBadge(withId: "explorer")
        }
        
        // Badge "Mattiniero" - 5 allenamenti prima delle 9:00
        if morningWorkoutsCompleted >= 5 {
            awardBadge(withId: "morning")
        }
        
        // Badge "Cardio Pro" - 15 allenamenti cardiovascolari
        if cardioWorkoutsCompleted >= 15 {
            awardBadge(withId: "cardio_pro")
        }
        
        // Badge "Maratoneta" - 50 km totali di corsa
        if runningDistanceKm >= 50 {
            awardBadge(withId: "marathoner")
        }
        
        // Badge "Flessibilità" - 8 sessioni di stretching/yoga
        if flexibilityWorkoutsCompleted >= 8 {
            awardBadge(withId: "flexibility")
        }
        
        // Badge "Fuoco" - 5000 calorie bruciate totali
        if totalCaloriesBurned >= 5000 {
            awardBadge(withId: "fire")
        }
        
        // Badge "Notturno" - 5 allenamenti dopo le 20:00
        if eveningWorkoutsCompleted >= 5 {
            awardBadge(withId: "night_owl")
        }
        
        // Badge "Campione" - 30 allenamenti totali
        if totalWorkoutsCompleted >= 30 {
            awardBadge(withId: "champion")
        }
        
        // Badge "Resistenza" - Allenamento di durata superiore a 60 minuti
        if longestWorkoutDuration >= 60 {
            awardBadge(withId: "endurance")
        }
        
        // Badge "Precisione" - 20 esercizi di precisione
        if precisionExercisesCompleted >= 20 {
            awardBadge(withId: "precision")
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
