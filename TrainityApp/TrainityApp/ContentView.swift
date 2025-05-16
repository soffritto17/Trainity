import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Menù", systemImage: "house")
                }
            
                FitnessQuestionnaireView()
                    .environmentObject(workoutManager)
            
                    .tabItem {
                        Label("Questionario", systemImage: "list.bullet.clipboard")
                    }
            WorkoutHistoryView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Cronologia", systemImage: "clock.arrow.circlepath")
                }
            
            ProfileView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
        }
        .accentColor(Color(red: 0.1, green: 0.4, blue: 0.4))
    }
}

#Preview {
    ContentView()
}
