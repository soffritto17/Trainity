import SwiftUI

struct CustomizeWorkoutView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var navigateToNewWorkout = false
    @Environment(\.presentationMode) var presentationMode
    
    // Definisci un init() dove configuriamo l'aspetto UIKit sottostante
    init() {
        // Configura l'aspetto globale dei UITableView
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1.0)
        
        // Configura anche lo sfondo delle celle
        let cellAppearance = UITableViewCell.appearance()
        cellAppearance.backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1.0)
        
        // Rimuove le linee separatrici tra le celle
        tableViewAppearance.separatorStyle = .none
        
        // Importante: configura anche il colore di sfondo del grouped background
        let groupedBackground = UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1.0)
        UITableViewCell.appearance().backgroundColor = groupedBackground
        UICollectionView.appearance().backgroundColor = groupedBackground
    }
    
    var body: some View {
        // Il tuo layout originale esatto senza modifiche alla struttura
        ZStack {
            // Colore aggiornato per corrispondere a WorkoutDetailView
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
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
                    .background(Color(red: 0.9, green: 0.95, blue: 0.95))
                }
            }
            
            // NavigationLink nascosto
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
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            },
            trailing: Button(action: {
                navigateToNewWorkout = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            }
        )
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        workoutManager.savedWorkouts.remove(atOffsets: offsets)
    }
}

// Estensione per modificare il colore di sfondo della View di sistema
extension View {
    func listBackgroundModifier() -> some View {
        self.onAppear {
            UITableView.appearance().backgroundColor = UIColor(red: 0.9, green: 0.95, blue: 0.95, alpha: 1.0)
        }
    }
}
