import SwiftUI

struct MyWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var selectedWorkout: Workout?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(Color("wht").opacity(0.3))
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: "plus")
                            .font(.system(size: 40))
                            .foregroundColor(Color("blk"))
                    }
                    .padding(.top, 30)
                    
                    Text("My Workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                    
                    if let workout = selectedWorkout ?? workoutManager.savedWorkouts.first {
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Image(systemName: "dumbbell.fill")
                                    .foregroundColor(Color("blk"))
                                Text(workout.goal)
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                            }
                            
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color("blk"))
                                Text("\(workout.duration) min")
                                    .foregroundColor(Color("blk"))
                                Spacer()
                                Text("\(workout.exercises.count)")
                                    .foregroundColor(Color("blk"))
                            }
                            
                            ForEach(workout.exercises) { exercise in
                                HStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color("blk"))
                                    
                                    Text(exercise.name)
                                        .font(.headline)
                                        .foregroundColor(Color("blk"))
                                    
                                    Spacer()
                                    
                                    Text("\(exercise.sets)x \(exercise.reps)")
                                        .foregroundColor(Color("blk"))
                                }
                                .padding(.vertical, 5)
                            }
                            
                            Button(action: {
                                // Start workout action
                            }) {
                                Text("Start Workout")
                                    .font(.headline)
                                    .foregroundColor(Color("wht"))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("blk"))
                                    .cornerRadius(10)
                            }
                            .padding(.top)
                        }
                        .padding()
                        .background(Color("wht"))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    } else {
                        Text("No workouts saved")
                            .foregroundColor(Color("blk").opacity(0.5))
                            .padding()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
}
