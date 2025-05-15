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
}

struct WorkoutRecord: Identifiable {
    var id = UUID()
    var workout: Workout
    var date: Date
    var duration: Int
    var completed: Bool
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
        restTime: 30
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
        restTime: 20
    )
    
    // Esempio di badge
    let exampleBadges = [
        Badge(id: "first_workout", name: "First Workout", description: "Completa il tuo primo allenamento", imageName: "star.fill"),
        Badge(id: "week_streak", name: "Week Streak", description: "Completa allenamenti per 7 giorni consecutivi", imageName: "flame.fill"),
        Badge(id: "muscle_builder", name: "Muscle Builder", description: "Completa 10 allenamenti di costruzione muscolare", imageName: "dumbbell.fill")
    ]
    
    init() {
        savedWorkouts.append(buildMuscleWorkout)
        savedWorkouts.append(weightLossWorkout)
        badges = exampleBadges
        
        // Esempio di storico allenamenti
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        workoutHistory = [
            WorkoutRecord(
                workout: buildMuscleWorkout,
                date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                duration: 32,
                completed: true
            ),
            WorkoutRecord(
                workout: weightLossWorkout,
                date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                duration: 38,
                completed: true
            )
        ]
        
        totalWorkoutsCompleted = workoutHistory.count
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
            completed: true
        )
        
        workoutHistory.append(record)
        totalWorkoutsCompleted += 1
        
        // Aggiorna lo streak
        updateStreak()
        
        // Verifica i badge
        checkAndAwardBadges()
    }
    
    private func updateStreak() {
        // Logica semplificata per lo streak
        weeklyStreak += 1
    }
    
    private func checkAndAwardBadges() {
        // Logica per assegnare i badge
        if totalWorkoutsCompleted == 1 {
            // Premio per il primo allenamento
            if !badges[0].isEarned {
                badges[0].isEarned = true
                badgesEarned += 1
            }
        }
        
        if weeklyStreak >= 7 {
            // Premio per lo streak settimanale
            if !badges[1].isEarned {
                badges[1].isEarned = true
                badgesEarned += 1
            }
        }
    }
}


