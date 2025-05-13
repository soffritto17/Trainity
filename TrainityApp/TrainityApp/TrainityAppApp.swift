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

struct Workout: Identifiable {
    var id = UUID()
    var name: String
    var duration: Int // in minuti
    var exercises: [Exercise]
    var goal: String
    var restTime: Int // in secondi
}

class WorkoutManager: ObservableObject {
    @Published var dailyChallengeCompleted = [false, false, false, false, false, false, false]
    @Published var savedWorkouts: [Workout] = []
    @Published var progress: Int = 24
    
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
    
    init() {
        savedWorkouts.append(buildMuscleWorkout)
    }
    
    func generateWorkout(duration: Int, exerciseCount: Int, goal: String, restTime: Int) -> Workout {
        // Qui implementeresti la logica per generare un allenamento personalizzato
        // Per ora restituiamo l'allenamento di esempio
        return buildMuscleWorkout
    }
}
