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
            Color("wht").edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header dell'allenamento
                    VStack(alignment: .leading, spacing: 10) {
                        Text(record.workout.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color("blk"))
                        
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                            Text("Completato")
                                .font(.headline)
                                .foregroundColor(.green)
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Informazioni dell'allenamento
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Dettagli Allenamento")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        HStack {
                            Label("Data", systemImage: "calendar")
                                .foregroundColor(Color("blk").opacity(0.6))
                            Spacer()
                            Text(formattedDateTime(record.date))
                                .fontWeight(.semibold)
                                .foregroundColor(Color("blk"))
                        }
                        
                        HStack {
                            Label("Esercizi", systemImage: "figure.strengthtraining.traditional")
                                .foregroundColor(Color("blk").opacity(0.6))
                            Spacer()
                            Text("\(record.workout.exercises.count)")
                                .fontWeight(.semibold)
                                .foregroundColor(Color("blk"))
                        }
                        
                        if record.caloriesBurned > 0 {
                            HStack {
                                Label("Calorie", systemImage: "flame")
                                    .foregroundColor(Color("blk").opacity(0.6))
                                Spacer()
                                Text("\(record.caloriesBurned) cal")
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color("blk"))
                            }
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Lista degli esercizi
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Esercizi Completati")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        ForEach(record.workout.exercises, id: \.id) { exercise in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                
                                HStack {
                                    HStack {
                                        Image(systemName: "repeat")
                                            .foregroundColor(Color("blk").opacity(0.6))
                                        Text("Serie: \(exercise.sets)")
                                            .font(.subheadline)
                                            .foregroundColor(Color("blk").opacity(0.6))
                                    }
                                    
                                    Text("•")
                                        .foregroundColor(Color("blk").opacity(0.6))
                                    
                                    HStack {
                                        Image(systemName: "arrow.up.and.down")
                                            .foregroundColor(Color("blk").opacity(0.6))
                                        Text("Ripetizioni: \(exercise.reps)")
                                            .font(.subheadline)
                                            .foregroundColor(Color("blk").opacity(0.6))
                                    }
                                    
                                    if let weight = exercise.weight {
                                        Text("•")
                                            .foregroundColor(Color("blk").opacity(0.6))
                                        
                                        HStack {
                                            Image(systemName: "scalemass")
                                                .foregroundColor(Color("blk").opacity(0.6))
                                            Text("Peso: \(weight, specifier: "%.1f") kg")
                                                .font(.subheadline)
                                                .foregroundColor(Color("blk").opacity(0.6))
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
                            .background(Color("wht"))
                            .cornerRadius(10)
                            .shadow(color: Color("blk").opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
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
