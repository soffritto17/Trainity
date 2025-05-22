import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showingEditView = false
    @State private var showingDeleteAlert = false
    @State private var exerciseToDelete: Exercise?
    
    var body: some View {
        ZStack {
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 20) {
                        Text(workout.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("blk"))
                            .padding(.top, 40)
                        
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Esercizi:")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                                .padding(.bottom, 5)
                            
                            ForEach(workout.exercises) { exercise in
                                ExerciseRow(exercise: exercise, onDelete: {
                                    exerciseToDelete = exercise
                                    showingDeleteAlert = true
                                })
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                VStack {
                    Divider()
                        .background(Color("blk").opacity(0.3))
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            Text("Modifica")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("wht"))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("blk"), lineWidth: 1)
                                )
                        }
                        
                        NavigationLink(destination: ActiveWorkoutView(workout: workout)) {
                            Text("Inizia Allenamento")
                                .font(.headline)
                                .foregroundColor(Color("wht"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("blk"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color("wht"))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("blk"))
            }
        )
        .sheet(isPresented: $showingEditView) {
            EditWorkoutView(workout: workout, workoutManager: workoutManager)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Eliminare esercizio"),
                message: Text("Sei sicuro di voler eliminare questo esercizio?"),
                primaryButton: .destructive(Text("Elimina")) {
                    if let exerciseToDelete = exerciseToDelete,
                       let index = workoutManager.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
                        var updatedWorkout = workout
                        updatedWorkout.exercises.removeAll(where: { $0.id == exerciseToDelete.id })
                     
                        workoutManager.savedWorkouts[index] = updatedWorkout
                    }
                },
                secondaryButton: .cancel(Text("Annulla"))
            )
        }
    }
}
