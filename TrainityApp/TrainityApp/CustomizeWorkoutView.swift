import SwiftUI

struct CustomizeWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var navigateToNewWorkout = false
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        let bgColor = UIColor(named: "wht") ?? .white
        UITableView.appearance().backgroundColor = bgColor
        UITableViewCell.appearance().backgroundColor = bgColor
        UITableView.appearance().separatorStyle = .none
        UICollectionView.appearance().backgroundColor = bgColor
    }
    
    var body: some View {
        ZStack {
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                if workoutManager.savedWorkouts.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        
                        Image(systemName: "dumbbell")
                            .font(.system(size: 60))
                            .foregroundColor(Color("blk").opacity(0.3))
                        
                        VStack(spacing: 10) {
                            Text("No Workout Saved")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("blk"))
                            
                            Text("Press + to create a new workout")
                                .font(.body)
                                .foregroundColor(Color("blk").opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("wht"))
                } else {
                    List {
                        ForEach(workoutManager.savedWorkouts) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                ImprovedWorkoutRowView(workout: workout)
                            }
                            .listRowBackground(Color("wht"))
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteWorkout)
                    }
                    .listStyle(.plain)
                    .background(Color("wht"))
                    .scrollContentBackground(.hidden)
                }
            }
            .background(Color("wht"))
            
            NavigationLink(
                destination: CreateNewWorkoutView().environmentObject(workoutManager),
                isActive: $navigateToNewWorkout
            ) {
                EmptyView()
            }
        }
        .navigationTitle("My Workouts")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("blk"))
                    .font(.system(size: 18, weight: .medium))
            },
            trailing: Button(action: {
                navigateToNewWorkout = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color("blk"))
                    .font(.system(size: 18, weight: .medium))
            }
        )
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        workoutManager.savedWorkouts.remove(atOffsets: offsets)
    }
}

struct ImprovedWorkoutRowView: View {
    let workout: Workout
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 15) {
                // Icona dell'allenamento
                VStack {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("blk"))
                        .frame(width: 40, height: 40)
                        .background(Color("blk").opacity(0.1))
                        .clipShape(Circle())
                }
                
                // Contenuto principale
                VStack(alignment: .leading, spacing: 8) {
                    // Titolo dell'allenamento
                    HStack {
                        Text(workout.name)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("blk"))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        Spacer(minLength: 0)
                    }
                    
                    // Informazioni sull'allenamento
                    HStack(spacing: 15) {
                        // Numero di esercizi
                        HStack(spacing: 4) {
                            Image(systemName: "list.bullet")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color("blk").opacity(0.6))
                            
                            Text("\(workout.exercises.count) esercizi")
                                .font(.subheadline)
                                .foregroundColor(Color("blk").opacity(0.7))
                        }
                    }
                    
                    
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color("wht"))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("blk").opacity(0.1)),
                alignment: .bottom
            )
        }
    }
    
}

