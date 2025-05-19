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
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Contenuto scrollabile
                ScrollView {
                    VStack(spacing: 20) {
                        Text(workout.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            .padding(.top, 40)
                        
                        // Lista esercizi
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Esercizi:")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .padding(.bottom, 5)
                            
                            ForEach(workout.exercises) { exercise in
                                ExerciseRow(exercise: exercise, onDelete: {
                                    exerciseToDelete = exercise
                                    showingDeleteAlert = true
                                })
                            }
                        }
                        .padding(.horizontal)
                        
                        // Aggiungiamo spazio per evitare che l'ultimo elemento sia coperto dai pulsanti
                        Spacer()
                            .frame(height: 100)
                    }
                }
                
                // Pulsanti fissi in basso
                VStack {
                    Divider()
                        .background(Color(red: 0.1, green: 0.4, blue: 0.4).opacity(0.3))
                        .padding(.bottom, 8)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingEditView = true
                        }) {
                            Text("Modifica")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 0.1, green: 0.4, blue: 0.4), lineWidth: 1)
                                )
                        }
                        
                        // Sostituito il Button con NavigationLink
                        NavigationLink(destination: ActiveWorkoutView(workout: workout)) {
                            Text("Inizia Allenamento")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color(red: 0.9, green: 0.95, blue: 0.95))
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            }
        )
        .sheet(isPresented: $showingEditView) {
            // Passa il workout al foglio di modifica
            EditWorkoutView(workout: workout, workoutManager: workoutManager)
        }
        .alert(isPresented: $showingDeleteAlert) {
            Alert(
                title: Text("Eliminare esercizio"),
                message: Text("Sei sicuro di voler eliminare questo esercizio?"),
                primaryButton: .destructive(Text("Elimina")) {
                    if let exerciseToDelete = exerciseToDelete,
                       let index = workoutManager.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
                        // Crea una copia aggiornata del workout
                        var updatedWorkout = workout
                        updatedWorkout.exercises.removeAll(where: { $0.id == exerciseToDelete.id })
                        
                        // Aggiorna la durata
                        updatedWorkout.duration = updatedWorkout.exercises.count * 5
                        
                        // Aggiorna il workout nel workoutManager
                        workoutManager.savedWorkouts[index] = updatedWorkout
                    }
                },
                secondaryButton: .cancel(Text("Annulla"))
            )
        }
    }
}
