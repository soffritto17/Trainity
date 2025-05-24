import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Menù", systemImage: "list.dash")
                }
            
            WorkoutHistoryView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Workout History", systemImage: "clock.arrow.circlepath")
                }
            
            ProfileView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .accentColor(Color("blk"))
    }
}

#Preview {
    ContentView()
}
