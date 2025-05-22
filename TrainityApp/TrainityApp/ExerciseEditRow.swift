import SwiftUI

struct ExerciseEditRow: View {
    @Binding var exercise: Exercise
    @State private var setsText: String = ""
    @State private var repsText: String = ""
    
    init(exercise: Binding<Exercise>) {
        self._exercise = exercise
        self._setsText = State(initialValue: "\(exercise.wrappedValue.sets)")
        self._repsText = State(initialValue: "\(exercise.wrappedValue.reps)")
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(Color("blk"))
                Spacer()
            }
            
            HStack {
                Text("Serie:")
                    .font(.subheadline)
                    .foregroundColor(Color("blk").opacity(0.6))
                
                TextField("0", text: Binding(
                    get: { setsText },
                    set: { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        setsText = filtered
                        if let sets = Int(filtered), sets > 0 {
                            exercise.sets = sets
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .frame(width: 50)
                .padding(8)
                .background(Color("wht"))
                .cornerRadius(8)
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("Rep:")
                    .font(.subheadline)
                    .foregroundColor(Color("blk").opacity(0.6))
                
                TextField("0", text: Binding(
                    get: { repsText },
                    set: { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        repsText = filtered
                        if let reps = Int(filtered), reps > 0 {
                            exercise.reps = reps
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .frame(width: 50)
                .padding(8)
                .background(Color("wht"))
                .cornerRadius(8)
                .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color("wht"))
        .cornerRadius(10)
    }
}
