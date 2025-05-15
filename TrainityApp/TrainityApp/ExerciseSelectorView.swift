//
//  ExerciseSelectorView.swift
//  TrainityAppUITests
//
//  Created by Giovanni De Rosa on 15/05/25.
//

import SwiftUI



struct ExerciseSelectorView: View {
    var onExerciseSelected: (Exercise) -> Void
    @State private var searchText: String = ""
    @State private var customExerciseName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    // Esempio di database di esercizi
    let exerciseDatabase = [
        "Panca Piana", "Squat", "Stacchi da Terra", "Pull Up", "Push Up",
        "Crunch", "Plank", "Curl Bicipiti", "Tricipiti", "Calf Raise",
        "Leg Press", "Lat Machine", "Shoulder Press", "Lunges", "Dip"
    ]
    
    var filteredExercises: [String] {
        if searchText.isEmpty {
            return exerciseDatabase
        } else {
            return exerciseDatabase.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
                
                VStack {
                    TextField("Cerca esercizio", text: $searchText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding()
                    
                    // Custom exercise input
                    HStack {
                        TextField("Aggiungi esercizio personalizzato", text: $customExerciseName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                        
                        Button(action: {
                            if !customExerciseName.isEmpty {
                                let newExercise = Exercise(name: customExerciseName, sets: 3, reps: 10)
                                onExerciseSelected(newExercise)
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                    
                    List {
                        ForEach(filteredExercises, id: \.self) { exerciseName in
                            Button(action: {
                                let exercise = Exercise(name: exerciseName, sets: 3, reps: 10)
                                onExerciseSelected(exercise)
                            }) {
                                Text(exerciseName)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
                .navigationTitle("Seleziona Esercizio")
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Chiudi")
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    }
                )
            }
        }
    }
}

