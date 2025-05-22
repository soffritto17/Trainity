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
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Spacer()
            }
            
            HStack {
                Text("Serie:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("0", text: Binding(
                    get: {
                        setsText
                    },
                    set: { newValue in
                        // Filtra per permettere solo numeri
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        setsText = filtered
                        
                        // Aggiorna il valore dell'esercizio
                        if let sets = Int(filtered), sets > 0 {
                            exercise.sets = sets
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .frame(width: 50)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .multilineTextAlignment(.center)
                
                Spacer()
                
                Text("Rep:")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                TextField("0", text: Binding(
                    get: {
                        repsText
                    },
                    set: { newValue in
                        // Filtra per permettere solo numeri
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        repsText = filtered
                        
                        // Aggiorna il valore dell'esercizio
                        if let reps = Int(filtered), reps > 0 {
                            exercise.reps = reps
                        }
                    }
                ))
                .keyboardType(.numberPad)
                .frame(width: 50)
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
