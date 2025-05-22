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
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                Text("Crea programma")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("blk"))
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Nome programma
                        VStack(alignment: .leading) {
                            Text("Nome programma")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                            
                            TextField("Inserisci nome", text: $workoutName)
                                .padding()
                                .background(Color("wht"))
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                        
                        // Esercizi
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Esercizi")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            if exercises.isEmpty {
                                Text("Nessun esercizio aggiunto")
                                    .foregroundColor(.gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("wht").opacity(0.5))
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
                                .foregroundColor(Color("blk"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("wht"))
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                        
                        // Eliminazione esercizi
                        if !exercises.isEmpty {
                            VStack(alignment: .leading) {
                                Text("Gestione esercizi")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                    .padding(.horizontal)
                                
                                ForEach(exercises.indices, id: \.self) { index in
                                    HStack {
                                        Text(exercises[index].name)
                                            .foregroundColor(Color("blk"))
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            exercises.remove(at: index)
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding()
                                    .background(Color("wht"))
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
        .sheet(isPresented: $showExerciseSelector) {
            ExerciseSelectorView(onExerciseSelected: { exercise in
                exercises.append(exercise)
                showExerciseSelector = false
            })
        }
    }
    
    private func saveWorkout() {
        let calculatedDuration = exercises.count * 5
        
        let newWorkout = Workout(
            name: workoutName,
            
            exercises: exercises,
           
            restTime: restTime
        )
        
        workoutManager.savedWorkouts.append(newWorkout)
    }
}
