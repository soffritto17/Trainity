import SwiftUI

struct EditWorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    var workout: Workout
    var workoutManager: WorkoutManager
    
    @State private var workoutName: String
    @State private var exercises: [Exercise]
    @State private var showExerciseSelector = false
    @State private var showDeleteAlert = false
    @State private var exerciseToDeleteIndex: Int? = nil
    
    init(workout: Workout, workoutManager: WorkoutManager) {
        self.workout = workout
        self.workoutManager = workoutManager
        _workoutName = State(initialValue: workout.name)
        _exercises = State(initialValue: workout.exercises)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Edit Workout")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("blk"))
                            .padding(.top, 20)
                        
                        VStack(alignment: .leading) {
                            Text("Workout Name")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                            
                            TextField("Insert Name", text: $workoutName)
                                .padding()
                                .background(Color("wht"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Exercises")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                
                                Spacer()
                                
                                Text("Total: \(exercises.count)")
                                    .font(.subheadline)
                                    .foregroundColor(Color("blk"))
                            }
                            .padding(.horizontal)
                            
                            if exercises.isEmpty {
                                Text("No exercises added yet.")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("wht").opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            } else {
                                ForEach(exercises.indices, id: \.self) { index in
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(exercises[index].name)
                                                .font(.headline)
                                                .foregroundColor(Color("blk"))
                                            
                                            Spacer()
                                            
                                            Button(action: {
                                                exerciseToDeleteIndex = index
                                                showDeleteAlert = true
                                            }) {
                                                Image(systemName: "trash")
                                                    .foregroundColor(.red)
                                                    .padding(8)
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.top)
                                        
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Set: \(exercises[index].sets)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("blk"))
                                                    .padding(.bottom, 4)
                                                
                                                Stepper("", value: $exercises[index].sets, in: 1...10)
                                                    .labelsHidden()
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .leading) {
                                                Text("Reps: \(exercises[index].reps)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color("blk"))
                                                    .padding(.bottom, 4)
                                                
                                                Stepper("", value: $exercises[index].reps, in: 1...30)
                                                    .labelsHidden()
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                    }
                                    .background(Color("wht"))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                    .padding(.vertical, 5)
                                }
                            }
                            
                            Button(action: {
                                showExerciseSelector = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add Exercise")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(Color("blk"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("wht"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            saveWorkout()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save Edits")
                                .font(.headline)
                                .foregroundColor(Color("wht"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("blk"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .disabled(workoutName.isEmpty || exercises.isEmpty)
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                    .foregroundColor(Color("blk"))
            )
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Exercise"),
                    message: Text("Are you sure you want to delete this exercise?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = exerciseToDeleteIndex {
                            exercises.remove(at: index)
                            exerciseToDeleteIndex = nil
                        }
                    },
                    secondaryButton: .cancel(Text("Cancel")) {
                        exerciseToDeleteIndex = nil
                    }
                )
            }
        }
        .sheet(isPresented: $showExerciseSelector) {
            ExerciseSelectorView(onExerciseSelected: { exercise in
                exercises.append(exercise)
                showExerciseSelector = false
            })
        }
    }
    
    private func saveWorkout() {
        if let index = workoutManager.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
            var updatedWorkout = workout
            updatedWorkout.name = workoutName
            updatedWorkout.exercises = exercises
           
            workoutManager.savedWorkouts[index] = updatedWorkout
        }
    }
}
