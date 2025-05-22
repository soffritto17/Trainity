//
//  WorkoutRecordDetailView.swift
//  TrainityApp
//
//  Created by TrainityApp on 22/05/25.
//

import SwiftUI

struct WorkoutRecordDetailView: View {
    let record: WorkoutRecord
    @Environment(\.presentationMode) var presentationMode
    
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
                    .frame(maxWidth: .infinity, alignment: .leading)
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
                        }
                        
                        HStack {
                            Label("Esercizi", systemImage: "figure.strengthtraining.traditional")
                                .foregroundColor(Color("blk").opacity(0.6))
                            Spacer()
                            Text("\(record.workout.exercises.count)")
                                .fontWeight(.semibold)
                        }
                        
                        if record.caloriesBurned > 0 {
                            HStack {
                                Label("Calorie", systemImage: "flame")
                                    .foregroundColor(Color("blk").opacity(0.6))
                                Spacer()
                                Text("\(record.caloriesBurned) cal")
                                    .fontWeight(.semibold)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Lista degli esercizi con dettagli per serie
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Esercizi Completati")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        ForEach(record.workout.exercises, id: \.id) { exercise in
                            VStack(alignment: .leading, spacing: 12) {
                                // Nome dell'esercizio
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                
                                // Dettagli per ogni serie
                                VStack(alignment: .leading, spacing: 8) {
                                    ForEach(1...exercise.sets, id: \.self) { setNumber in
                                        let setIndex = setNumber - 1
                                        
                                        HStack {
                                            Text("Serie \(setNumber):")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("blk"))
                                                .frame(width: 70, alignment: .leading)
                                            
                                            HStack(spacing: 15) {
                                                // Ripetizioni effettive per questa serie
                                                HStack(spacing: 4) {
                                                    Image(systemName: "arrow.up.and.down")
                                                        .font(.caption)
                                                        .foregroundColor(Color("blk").opacity(0.6))
                                                    
                                                    let actualReps = exercise.actualReps?[setIndex] ?? exercise.reps
                                                    Text("\(actualReps) rep")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color("blk").opacity(0.7))
                                                }
                                                
                                                // Peso effettivo per questa serie
                                                HStack(spacing: 4) {
                                                    Image(systemName: "scalemass")
                                                        .font(.caption)
                                                        .foregroundColor(Color("blk").opacity(0.6))
                                                    
                                                    let actualWeight = exercise.actualWeights?[setIndex] ?? exercise.weight ?? 0.0
                                                    Text("\(actualWeight, specifier: "%.1f") kg")
                                                        .font(.subheadline)
                                                        .foregroundColor(Color("blk").opacity(0.7))
                                                }
                                                
                                                Spacer()
                                                
                                                // Stato completamento serie
                                                Image(systemName: "checkmark.circle.fill")
                                                    .font(.caption)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                        .padding(.vertical, 4)
                                        .padding(.horizontal, 12)
                                        .background(Color("blk").opacity(0.03))
                                        .cornerRadius(8)
                                    }
                                }
                                
                                // Riepilogo totale dell'esercizio
                                HStack {
                                    HStack(spacing: 4) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                        Text("Esercizio completato")
                                            .font(.caption)
                                            .foregroundColor(.green)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("Totale: \(exercise.sets) serie")
                                        .font(.caption)
                                        .foregroundColor(Color("blk").opacity(0.6))
                                }
                                .padding(.top, 4)
                            }
                            .padding()
                            .background(Color("wht"))
                            .cornerRadius(10)
                            .shadow(color: Color("blk").opacity(0.05), radius: 2, x: 0, y: 1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color("blk"))
            }
        )
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
