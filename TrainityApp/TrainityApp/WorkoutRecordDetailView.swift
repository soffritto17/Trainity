//
//  WorkoutRecordDetailView.swift
//  TrainityApp
//
//  Created by TrainityApp on 22/05/25.
//

import SwiftUI

struct WorkoutRecordDetailView: View {
    let record: WorkoutRecord
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header dell'allenamento
                    VStack(alignment: .leading, spacing: 10) {
                        Text(record.workout.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Completato")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                        
                       
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Informazioni dell'allenamento
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Dettagli Allenamento")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        HStack {
                            Label("Data", systemImage: "calendar")
                                .foregroundColor(.gray)
                            Spacer()
                            Text(formattedDateTime(record.date))
                                .fontWeight(.semibold)
                        }
                        
                       
                        
                        HStack {
                            Label("Esercizi", systemImage: "figure.strengthtraining.traditional")
                                .foregroundColor(.gray)
                            Spacer()
                            Text("\(record.workout.exercises.count)")
                                .fontWeight(.semibold)
                        }
                        
                        if record.caloriesBurned > 0 {
                            HStack {
                                Label("Calorie", systemImage: "flame")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text("\(record.caloriesBurned) cal")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Lista degli esercizi
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Esercizi Completati")
                            .font(.headline)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        
                        ForEach(record.workout.exercises, id: \.id) { exercise in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                HStack {
                                    HStack {
                                        Image(systemName: "repeat")
                                            .foregroundColor(.gray)
                                        Text("Serie: \(exercise.sets)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("•")
                                        .foregroundColor(.gray)
                                    
                                    HStack {
                                        Image(systemName: "arrow.up.and.down")
                                            .foregroundColor(.gray)
                                        Text("Ripetizioni: \(exercise.reps)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    if let weight = exercise.weight {
                                        Text("•")
                                            .foregroundColor(.gray)
                                        
                                        HStack {
                                            Image(systemName: "scalemass")
                                                .foregroundColor(.gray)
                                            Text("Peso: \(weight, specifier: "%.1f") kg")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                }
                                
                                if exercise.isCompleted {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("Completato")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Dettagli Allenamento")
    }
    
    func formattedDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

