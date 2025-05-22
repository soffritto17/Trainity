import SwiftUI

struct ExerciseTrackingCard: View {
    let exercise: Exercise
    let isActive: Bool
    let isCompleted: Bool
    let completedReps: [Int]
    let onSetComplete: (Int, Int) -> Void
    
    @State private var currentReps: [String] = []
    @State private var currentWeights: [String] = []
    
    init(exercise: Exercise, isActive: Bool, isCompleted: Bool, completedReps: [Int], onSetComplete: @escaping (Int, Int) -> Void) {
        self.exercise = exercise
        self.isActive = isActive
        self.isCompleted = isCompleted
        self.completedReps = completedReps
        self.onSetComplete = onSetComplete
        
        _currentReps = State(initialValue: completedReps.map { $0 > 0 ? "\($0)" : "" })
        _currentWeights = State(initialValue: Array(repeating: exercise.weight != nil ? String(format: "%.1f", exercise.weight!) : "", count: exercise.sets))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Header
            HStack {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(Color("blk"))
                
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
            
            Text("Range ripetizioni: \(max(exercise.reps - 2, 1))-\(exercise.reps)")
                .font(.subheadline)
                .foregroundColor(Color("blk").opacity(0.6))
            
            Text("Serie: \(exercise.sets)")
                .font(.subheadline)
                .foregroundColor(Color("blk").opacity(0.6))
            
            ForEach(0..<exercise.sets, id: \.self) { setIndex in
                HStack {
                    Text("Serie \(setIndex + 1):")
                        .font(.subheadline)
                        .foregroundColor(Color("blk"))
                    
                    Spacer()
                    
                    Text("Kg:")
                        .font(.caption)
                        .foregroundColor(Color("blk").opacity(0.6))
                    
                    TextField("0", text: Binding(
                        get: {
                            currentWeights.count > setIndex ? currentWeights[setIndex] : ""
                        },
                        set: { newValue in
                            while currentWeights.count <= setIndex {
                                currentWeights.append("")
                            }
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            currentWeights[setIndex] = filtered
                        }
                    ))
                    .keyboardType(.decimalPad)
                    .frame(width: 50)
                    .padding(8)
                    .background(Color("wht"))
                    .cornerRadius(8)
                    .disabled(!isActive && !isCompleted)
                    
                    Text("Rep:")
                        .font(.caption)
                        .foregroundColor(Color("blk").opacity(0.6))
                    
                    TextField("0", text: Binding(
                        get: {
                            currentReps.count > setIndex ? currentReps[setIndex] : ""
                        },
                        set: { newValue in
                            while currentReps.count <= setIndex {
                                currentReps.append("")
                            }
                            currentReps[setIndex] = newValue.filter { "0123456789".contains($0) }
                            
                            if let reps = Int(currentReps[setIndex]), reps > 0 {
                                onSetComplete(setIndex, reps)
                            }
                        }
                    ))
                    .keyboardType(.numberPad)
                    .frame(width: 50)
                    .padding(8)
                    .background(Color("wht"))
                    .cornerRadius(8)
                    .disabled(!isActive && !isCompleted)
                }
                .padding(8)
                .background(Color("wht").opacity(isActive ? 1.0 : 0.5))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("wht").opacity(isActive ? 1.0 : 0.8))
                .shadow(color: isActive ? Color("blk").opacity(0.15) : .clear, radius: 3)
        )
        .opacity(isActive || isCompleted ? 1.0 : 0.7)
    }
}
