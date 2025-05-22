import SwiftUI

struct WorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(workout.name)
                .font(.headline)
                .foregroundColor(Color("blk"))
            
            HStack {
               
                Spacer()
                
                Label("\(workout.exercises.count) esercizi", systemImage: "list.bullet")
                    .font(.subheadline)
                    .foregroundColor(Color("blk").opacity(0.6))
            }
            
          
        }
        .padding(.vertical, 8)
    }
}
