
import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(workout.name)
                .font(.headline)
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            
            HStack {
                Label("\(workout.duration) min", systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Label("\(workout.exercises.count) esercizi", systemImage: "list.bullet")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Text("Obiettivo: \(workout.goal)")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
