//
//  CustomizeWorkoutView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 13/05/25.
//

import SwiftUI

struct CustomizeWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var showNewWorkoutSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.7, green: 0.9, blue: 0.9).edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Lista dei programmi salvati
                    if workoutManager.savedWorkouts.isEmpty {
                        VStack {
                            Spacer()
                            Text("Nessun programma salvato")
                                .font(.headline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            Text("Premi + per creare un nuovo programma")
                                .font(.subheadline)
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            Spacer()
                        }
                    } else {
                        List {
                            ForEach(workoutManager.savedWorkouts) { workout in
                                NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                    WorkoutRowView(workout: workout)
                                }
                            }
                            .onDelete(perform: deleteWorkout)
                        }
                        .listStyle(InsetGroupedListStyle())
                        .background(Color(red: 0.7, green: 0.9, blue: 0.9))
                    }
                }
            }
            .navigationTitle("I Miei Programmi")
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                },
                trailing: Button(action: {
                    showNewWorkoutSheet = true
                }) {
                    Image(systemName: "plus")
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
            )
        }
        .sheet(isPresented: $showNewWorkoutSheet) {
            CreateNewWorkoutView()
                .environmentObject(workoutManager)
        }
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        workoutManager.savedWorkouts.remove(atOffsets: offsets)
    }
}
