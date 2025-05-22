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
                Color("wht").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Cronologia")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                        .padding()
                    
                    if workoutManager.workoutHistory.isEmpty {
                        VStack {
                            Image(systemName: "calendar.badge.clock")
                                .font(.system(size: 60))
                                .foregroundColor(Color("blk"))
                                .padding()
                            
                            Text("Nessun allenamento completato")
                                .font(.headline)
                                .foregroundColor(Color("blk").opacity(0.6))
                                .multilineTextAlignment(.center)
                            
                            Text("Completa il tuo primo allenamento per visualizzare la cronologia")
                                .font(.subheadline)
                                .foregroundColor(Color("blk").opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("wht"))
                        .cornerRadius(15)
                        .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                    } else {
                        List {
                            ForEach(workoutManager.workoutHistory.sorted(by: { $0.date > $1.date })) { record in
                                NavigationLink(destination: WorkoutRecordDetailView(record: record)) {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(record.workout.name)
                                                .font(.headline)
                                                .foregroundColor(Color("blk"))
                                            
                                            Spacer()
                                            
                                            Image(systemName: "checkmark.seal.fill")
                                                .foregroundColor(Color("blk"))
                                        }
                                        
                                        HStack {
                                            Text(formattedDate(record.date))
                                                .font(.subheadline)
                                                .foregroundColor(Color("blk").opacity(0.6))
                                        }
                                    }
                                    .padding(.vertical, 5)
                                }
                                .listRowBackground(Color("wht"))
                            }
                            .onDelete { offsets in
                                workoutManager.deleteWorkoutRecord(at: offsets)
                            }
                        }
                        .background(Color("wht"))
                        .listStyle(InsetGroupedListStyle())
                        .scrollContentBackground(.hidden)
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
