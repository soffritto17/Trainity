//
//  CreateNewWorkoutView.swift
//  TrainityApp
//
//  Created by Giovanni De Rosa on 15/05/25.
//

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
        NavigationView {
            ZStack {
                Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Crea nuovo programma")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
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
                                ForEach(0..<exercises.count, id: \.self) { index in
                                    ExerciseRowView(exercise: $exercises[index])
                                        .padding(.vertical, 5)
                                }
                                .onDelete(perform: deleteExercise)
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
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Annulla")
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
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
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
