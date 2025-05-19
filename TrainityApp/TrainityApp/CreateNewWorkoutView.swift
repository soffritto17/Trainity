import SwiftUI

struct CreateNewWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode
    @State private var workoutName: String = ""
    @State private var restTime: Int = 30
    @State private var goal: String = "Build Muscle"
    @State private var exercises: [Exercise] = []
    @State private var showExerciseSelector = false
    
    let goalOptions = ["Build Muscle", "Weight Loss", "Endurance", "Strength"]
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Titolo in alto
                Text("Crea programma")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                // Resto del contenuto in uno ScrollView
                ScrollView {
                    VStack(spacing: 20) {
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
                        
                        // Exercises section
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Esercizi")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                Spacer()
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
                                    ExerciseEditRow(exercise: $exercises[index])
                                        .padding(.vertical, 5)
                                        .padding(.horizontal)
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
                        
                        // Pulsante per eliminare esercizi
                        if !exercises.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Gestione esercizi")
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                    .padding(.horizontal)
                                
                                ForEach(exercises.indices, id: \.self) { index in
                                    HStack {
                                        Text(exercises[index].name)
                                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            exercises.remove(at: index)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            saveWorkout()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Salva Programma")
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
        .sheet(isPresented: $showExerciseSelector) {
            ExerciseSelectorView(onExerciseSelected: { exercise in
                exercises.append(exercise)
                showExerciseSelector = false
            })
        }
    }
    
    private func saveWorkout() {
        // Calcola la durata in base agli esercizi
        let calculatedDuration = exercises.count * 5 // semplice esempio: 5 minuti per esercizio
        
        let newWorkout = Workout(
            name: workoutName,
            duration: calculatedDuration,
            exercises: exercises,
            goal: goal,
            restTime: restTime
        )
        
        workoutManager.savedWorkouts.append(newWorkout)
    }
}
