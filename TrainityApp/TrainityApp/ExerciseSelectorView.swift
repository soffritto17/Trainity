import SwiftUI

struct ExerciseSelectorView: View {
    var onExerciseSelected: (Exercise) -> Void
    @State private var searchText: String = ""
    @State private var customExerciseName: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    let exerciseDatabase = [
        "Bench Press", "Squat", "Deadlifts", "Pull Up", "Push Up",
        "Crunch", "Plank", "Biceps Curl", "Triceps", "Calf Raise",
        "Leg Press", "Lat Machine", "Shoulder Press", "Lunges", "Dip"
    ]
    
    var filteredExercises: [String] {
        if searchText.isEmpty {
            return exerciseDatabase
        } else {
            return exerciseDatabase.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                VStack {
                    TextField("Search Exercise", text: $searchText)
                        .padding()
                        .background(Color("wht"))
                        .cornerRadius(10)
                        .padding()
                    
                    List {
                        ForEach(filteredExercises, id: \.self) { exerciseName in
                            Button(action: {
                                let exercise = Exercise(name: exerciseName, sets: 3, reps: 10)
                                onExerciseSelected(exercise)
                            }) {
                                Text(exerciseName)
                                    .foregroundColor(Color("blk"))
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .scrollContentBackground(.hidden)
                    .background(Color("wht"))
                }
                .navigationTitle("Select Exercise")
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .foregroundColor(Color("blk"))
                    }
                )
            }
        }
    }
}
