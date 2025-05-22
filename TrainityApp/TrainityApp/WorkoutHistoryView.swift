import SwiftUI

struct WorkoutHistoryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Cronologia Allenamenti")
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
                                .foregroundColor(Color("blk").opacity(0.5))
                                .multilineTextAlignment(.center)
                            
                            Text("Completa il tuo primo allenamento per visualizzare la cronologia")
                                .font(.subheadline)
                                .foregroundColor(Color("blk").opacity(0.5))
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
                                        Label("\(record.duration) min", systemImage: "clock")
                                            .font(.subheadline)
                                            .foregroundColor(Color("blk").opacity(0.5))
                                        
                                        Spacer()
                                        
                                        Text(formattedDate(record.date))
                                            .font(.subheadline)
                                            .foregroundColor(Color("blk").opacity(0.5))
                                    }
                                    
                                    Text(record.workout.goal)
                                        .font(.caption)
                                        .padding(5)
                                        .background(Color("blk").opacity(0.05))
                                        .cornerRadius(5)
                                        .padding(.top, 2)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                        .onAppear {
                            if UserDefaults.standard.data(forKey: "WorkoutHistory") != nil {
                                // load logic if necessary
                            }
                        }
                        .background(Color("wht"))
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
        .environmentObject(WorkoutManager())
}
