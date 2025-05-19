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
        
        // Inizializza gli stati con le proprietà del workout
        _workoutName = State(initialValue: workout.name)
        _exercises = State(initialValue: workout.exercises)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Modifica Programma")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            .padding(.top, 20)
                        
                        // Nome programma
                        VStack(alignment: .leading) {
                            Text("Nome programma")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            
                            TextField("Inserisci nome", text: $workoutName)
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Esercizi
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Esercizi")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                Spacer()
                                
                                Text("Totale: \(exercises.count)")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                            .padding(.horizontal)
                            
                            if exercises.isEmpty {
                                Text("Nessun esercizio aggiunto")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white.opacity(0.5))
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                            } else {
                                ForEach(exercises.indices, id: \.self) { index in
                                    VStack(spacing: 0) {
                                        HStack {
                                            Text(exercises[index].name)
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                            
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
                                        
                                        // Dettagli serie e ripetizioni
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("Serie: \(exercises[index].sets)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                                    .padding(.bottom, 4)
                                                
                                                Stepper("", value: $exercises[index].sets, in: 1...10)
                                                    .labelsHidden()
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .leading) {
                                                Text("Ripetizioni: \(exercises[index].reps)")
                                                    .font(.subheadline)
                                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                                    .padding(.bottom, 4)
                                                
                                                Stepper("", value: $exercises[index].reps, in: 1...30)
                                                    .labelsHidden()
                                            }
                                        }
                                        .padding(.horizontal)
                                        .padding(.bottom)
                                    }
                                    .background(Color.white)
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
                                    Text("Aggiungi Esercizio")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            saveWorkout()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Salva Modifiche")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 40)
                        .disabled(workoutName.isEmpty || exercises.isEmpty)
                    }
                }
            }
            .navigationBarItems(
                leading: Button("Annulla") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            )
            .navigationBarTitleDisplayMode(.inline)
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Eliminare esercizio"),
                    message: Text("Sei sicuro di voler eliminare questo esercizio?"),
                    primaryButton: .destructive(Text("Elimina")) {
                        if let index = exerciseToDeleteIndex {
                            exercises.remove(at: index)
                            exerciseToDeleteIndex = nil
                        }
                    },
                    secondaryButton: .cancel(Text("Annulla")) {
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
        // Cerca l'indice del workout nel workoutManager
        if let index = workoutManager.savedWorkouts.firstIndex(where: { $0.id == workout.id }) {
            // Crea una copia aggiornata del workout
            var updatedWorkout = workout
            updatedWorkout.name = workoutName
            updatedWorkout.exercises = exercises
            
            // Calcola la durata in base agli esercizi
            updatedWorkout.duration = exercises.count * 5 // esempio: 5 minuti per esercizio
            
            // Aggiorna il workout nel workoutManager
            workoutManager.savedWorkouts[index] = updatedWorkout
        }
    }
}
