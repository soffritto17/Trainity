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
                
                Stepper("\(exercise.sets)", value: $exercise.sets, in: 1...10)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Spacer()
                
                Text("Ripetizioni:")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Stepper("\(exercise.reps)", value: $exercise.reps, in: 1...30)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
