import SwiftUI

struct ExerciseTrackingCard: View {
    let exercise: Exercise
    let isActive: Bool
    let isCompleted: Bool
    let completedReps: [Int]
    let onSetComplete: (Int, Int) -> Void
    let onWeightUpdate: ([Double?]) -> Void // Modificato: ora passa array di pesi per tutte le serie
    
    @Environment(\.colorScheme) var colorScheme // Aggiunto per rilevare dark mode
    @State private var currentReps: [String] = []
    @State private var currentWeights: [String] = []
    
    // Colori dinamici basati su dark mode
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.2) : Color("wht")
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color.white : Color("blk")
    }
    
    private var accentColor: Color {
        colorScheme == .dark ? Color.white : Color("blk")
    }
    
    private var fieldBackgroundColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color.gray.opacity(0.3)
    }
    
    private var inactiveBackgroundColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.1) : Color.white.opacity(0.8)
    }
    
    private var seriesBackgroundColor: Color {
        if isActive {
            return colorScheme == .dark ? Color.gray.opacity(0.3) : Color.white
        } else {
            return colorScheme == .dark ? Color.gray.opacity(0.15) : Color.white.opacity(0.5)
        }
    }
    
    init(exercise: Exercise, isActive: Bool, isCompleted: Bool, completedReps: [Int], onSetComplete: @escaping (Int, Int) -> Void, onWeightUpdate: @escaping ([Double?]) -> Void) {
        self.exercise = exercise
        self.isActive = isActive
        self.isCompleted = isCompleted
        self.completedReps = completedReps
        self.onSetComplete = onSetComplete
        self.onWeightUpdate = onWeightUpdate
        
        // Inizializza la state variable
        _currentReps = State(initialValue: completedReps.map { $0 > 0 ? "\($0)" : "" })
        
        // Inizializza i pesi per ogni serie
        var initialWeights: [String] = []
        for i in 0..<exercise.sets {
            if let actualWeights = exercise.actualWeights, i < actualWeights.count, let weight = actualWeights[i] {
                initialWeights.append(String(format: "%.1f", weight))
            } else if let weight = exercise.weight {
                initialWeights.append(String(format: "%.1f", weight))
            } else {
                initialWeights.append("")
            }
        }
        _currentWeights = State(initialValue: initialWeights)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header dell'esercizio
            HStack {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(accentColor)
                
                Spacer()
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else if isActive {
                    Text("In progress")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                }
            }
            
            // Visualizza il range delle ripetizioni (numero programma - 2)
            Text("Reps Range: \(max(exercise.reps - 2, 1))-\(exercise.reps)")
                .font(.subheadline)
                .foregroundColor(textColor.opacity(0.7))
            
            Text("Set: \(exercise.sets)")
                .font(.subheadline)
                .foregroundColor(textColor.opacity(0.7))
            
            // Serie
            ForEach(0..<exercise.sets, id: \.self) { setIndex in
                HStack {
                    Text("Set \(setIndex + 1):")
                        .font(.subheadline)
                        .foregroundColor(textColor)
                    
                    Spacer()
                    
                    // Campo per i kg
                    Text("Kg:")
                        .font(.caption)
                        .foregroundColor(textColor.opacity(0.7))
                    
                    TextField("0", text: Binding(
                        get: {
                            currentWeights.count > setIndex ? currentWeights[setIndex] : ""
                        },
                        set: { newValue in
                            // Assicurati che l'array sia abbastanza grande
                            while currentWeights.count <= setIndex {
                                currentWeights.append("")
                            }
                            
                            // Filtra per permettere solo numeri e punto decimale
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            currentWeights[setIndex] = filtered
                            
                            // Aggiorna tutti i pesi per tutte le serie
                            updateAllWeights()
                        }
                    ))
                    .keyboardType(.decimalPad)
                    .frame(width: 50)
                    .padding(8)
                    .background(fieldBackgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(8)
                    .disabled(!isActive && !isCompleted)
                    
                    // Campo per le ripetizioni
                    Text("Rep:")
                        .font(.caption)
                        .foregroundColor(textColor.opacity(0.7))
                    
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
                    .background(fieldBackgroundColor)
                    .foregroundColor(textColor)
                    .cornerRadius(8)
                    .disabled(!isActive && !isCompleted)
                }
                .padding(8)
                .background(seriesBackgroundColor)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isActive || isCompleted ? backgroundColor : inactiveBackgroundColor)
                .shadow(color: isActive ? shadowColor : Color.clear, radius: 3)
        )
        .opacity(isActive || isCompleted ? 1.0 : 0.7)
    }
    
    // Funzione per aggiornare tutti i pesi dell'esercizio
    private func updateAllWeights() {
        var weightsArray: [Double?] = []
        
        for weightString in currentWeights {
            if let weight = Double(weightString), weight > 0 {
                weightsArray.append(weight)
            } else {
                weightsArray.append(nil)
            }
        }
        
        onWeightUpdate(weightsArray)
    }
}
