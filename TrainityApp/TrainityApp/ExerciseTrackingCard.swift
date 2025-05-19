import SwiftUI

struct ExerciseTrackingCard: View {
    let exercise: Exercise
    let isActive: Bool
    let isCompleted: Bool
    let completedReps: [Int]
    let onSetComplete: (Int, Int) -> Void
    
    @State private var currentReps: [String] = []
    
    init(exercise: Exercise, isActive: Bool, isCompleted: Bool, completedReps: [Int], onSetComplete: @escaping (Int, Int) -> Void) {
        self.exercise = exercise
        self.isActive = isActive
        self.isCompleted = isCompleted
        self.completedReps = completedReps
        self.onSetComplete = onSetComplete
        
        // Inizializza la state variable
        _currentReps = State(initialValue: completedReps.map { $0 > 0 ? "\($0)" : "" })
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header dell'esercizio
            HStack {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isActive {
                    Text("In corso")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            
            // Visualizza il range delle ripetizioni (numero programma - 2)
            Text("Range ripetizioni: \(max(exercise.reps - 2, 1))-\(exercise.reps)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Serie: \(exercise.sets)")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Serie
            ForEach(0..<exercise.sets, id: \.self) { setIndex in
                HStack {
                    Text("Serie \(setIndex + 1):")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    // Modificato "Ripetizioni:" in "Rep:"
                    Text("Rep:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    TextField("0", text: Binding(
                        get: {
                            currentReps.count > setIndex ? currentReps[setIndex] : ""
                        },
                        set: { newValue in
                            // Assicurati che l'array sia abbastanza grande
                            while currentReps.count <= setIndex {
                                currentReps.append("")
                            }
                            
                            // Aggiorna il valore
                            currentReps[setIndex] = newValue.filter { "0123456789".contains($0) }
                            
                            // Notifica il completamento della serie se viene inserito un valore
                            if let reps = Int(currentReps[setIndex]), reps > 0 {
                                onSetComplete(setIndex, reps)
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .frame(width: 50)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(8)
                    .disabled(!isActive && !isCompleted)
                }
                .padding(8)
                .background(isActive ? Color.white : Color.white.opacity(0.5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isActive ? Color.white : Color.white.opacity(0.8))
                .shadow(color: isActive ? Color.gray.opacity(0.3) : Color.clear, radius: 3)
        )
        .opacity(isActive || isCompleted ? 1.0 : 0.7)
    }
}
