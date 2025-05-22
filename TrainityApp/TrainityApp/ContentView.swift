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
                    Label("Cronologia", systemImage: "clock.arrow.circlepath")
                }
            
            ProfileView()
                .environmentObject(workoutManager)
                .tabItem {
                    Label("Profilo", systemImage: "person.fill")
                }
        }
        .accentColor(Color("blk"))
    }
}

#Preview {
    ContentView()
}
