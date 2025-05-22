import SwiftUI

struct ExerciseEditRow: View {
    @Binding var exercise: Exercise
    
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
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Text("\(exercise.sets)")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .fontWeight(.semibold)
                
                Stepper("", value: $exercise.sets, in: 1...10)
                    .labelsHidden()
                    .scaleEffect(0.8)
                
                Spacer()
                
                Text("Rep:")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Text("\(exercise.reps)")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .fontWeight(.semibold)
                
                Stepper("", value: $exercise.reps, in: 1...30)
                    .labelsHidden()
                    .scaleEffect(0.8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}

