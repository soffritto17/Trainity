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
            
            VStack {
                if workoutManager.savedWorkouts.isEmpty {
                    VStack {
                        Spacer()
                        Text("Nessun programma salvato")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        Text("Premi + per creare un nuovo programma")
                            .font(.subheadline)
                            .foregroundColor(Color("blk"))
                        Spacer()
                    }
                    .background(Color("wht"))
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
        .navigationTitle("I Miei Programmi")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color("blk"))
            },
            trailing: Button(action: {
                navigateToNewWorkout = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color("blk"))
            }
        )
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        workoutManager.savedWorkouts.remove(atOffsets: offsets)
    }
}

extension View {
    func listBackgroundModifier() -> some View {
        self.onAppear {
            UITableView.appearance().backgroundColor = UIColor(named: "wht") ?? .white
        }
    }
}
