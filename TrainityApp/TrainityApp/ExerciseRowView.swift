import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(Color("blk"))
                
                HStack {
                    Text("Serie: \(exercise.sets)")
                        .font(.subheadline)
                        .foregroundColor(Color("blk"))
                    
                    Text("•")
                        .foregroundColor(Color("blk"))
                    
                    Text("Ripetizioni: \(exercise.reps)")
                        .font(.subheadline)
                        .foregroundColor(Color("blk"))
                    
                    Text("•")
                        .foregroundColor(Color("blk"))
                    
                    Text("Peso: \(exercise.weight ?? 0.0, specifier: "%.1f") kg")
                        .font(.subheadline)
                        .foregroundColor(Color("blk"))
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
        }
        .padding()
        .background(Color("wht"))
        .cornerRadius(10)
    }
}
