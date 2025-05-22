//
//  WorkoutHistoryView.swift
//  TrainityApp
//
//  Created by Antonio Fiorito on 15/05/25.
//

import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Cronologia Allenamenti")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                        .padding()
                    
                    if workoutManager.workoutHistory.isEmpty {
                        VStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 60))
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .padding()
                            
                            Text("Nessun allenamento completato")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            
                            Text("Completa il tuo primo allenamento per visualizzare la cronologia")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    } else {
                        List {
                            ForEach(workoutManager.workoutHistory.sorted(by: { $0.date > $1.date })) { record in
                                NavigationLink(destination: WorkoutRecordDetailView(record: record)) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(record.workout.name)
                                                .font(.headline)
                                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                        }
                                        
                                        HStack {
                                            
                                            
                                            Text(formattedDate(record.date))
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        
                                    }
                                    .padding(.vertical, 5)
                                }
                            }
                            .onDelete { offsets in
                                workoutManager.deleteWorkoutRecord(at: offsets)
                            }
                        }
                        .background(Color(red: 0.9, green: 0.95, blue: 0.95))
                        .listStyle(InsetGroupedListStyle())
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    WorkoutHistoryView()
}
