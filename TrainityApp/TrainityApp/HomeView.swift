import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    let motivationalQuotes = [
        "Fitness is like a relationship. You have to stay faithful to it for it to work.",
        "Strength doesn't come from what you can do. It comes from overcoming what you thought you couldn't do.",
        "It takes a little more strength to take another step forward.",
        "Change happens when commitment exceeds resistance.",
        "The best project you can work on is yourself.",
        "The more you sweat in training, the less you bleed in battle.",
        "Believe in yourself and you'll be unstoppable.",
        "Fatigue lasts an hour. Pride lasts forever.",
        "No pain, no gain. No effort, no result.",
        "Consistency is more important than perfection.",
        "Your body can handle almost anything. It's your mind you have to convince.",
        "Invest in yourself. It's the best investment you'll ever make.",
        "Don't wait. The moment will never be perfect.",
        "Obstacles are those frightening things you see when you take your eyes off your goal.",
        "Make your body your strongest weapon, not your weakness."
    ]
    
    var todaysQuote: String {
        let today = Calendar.current.component(.day, from: Date())
        return motivationalQuotes[today % motivationalQuotes.count]
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 0)
                        .frame(maxWidth: .infinity)
                        .edgesIgnoringSafeArea(.top)
                    
                    // Daily Challenge
                    NavigationLink(destination: DailyChallengeView().environmentObject(workoutManager)) {
                        homeTile(
                            icon: "flame.fill",
                            title: "Daily Challenge",
                            subtitle: "Complete daily workouts to earn badges"
                        )
                    }
                    
                    // My Workouts
                    NavigationLink(destination: CustomizeWorkoutView().environmentObject(workoutManager)) {
                        homeTile(
                            icon: "dumbbell.fill",
                            title: "My Workouts",
                            subtitle: "Create and manage your custom workouts"
                        )
                    }
                    
                    // Progress Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Progress")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        HStack {
                            progressBox(title: "\(workoutManager.totalWorkoutsCompleted)", label: "Workouts")
                            Divider().frame(height: 40)
                            progressBox(title: "\(workoutManager.weeklyStreak)", label: "Days Streak")
                            Divider().frame(height: 40)
                            progressBox(title: "\(workoutManager.badgesEarned)", label: "Badges")
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // Motivational Quote
                    VStack(alignment: .center, spacing: 10) {
                        Text("💪 Daily Motivation")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        Text(todaysQuote)
                            .font(.body)
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("blk").opacity(0.6))
                            .padding(.horizontal)
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    func homeTile(icon: String, title: String, subtitle: String) -> some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color("blk"))
                    .frame(width: 60, height: 60)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(Color("wht"))
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color("blk"))
                
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(Color("blk").opacity(0.6))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color("blk"))
        }
        .padding()
        .background(Color("wht"))
        .cornerRadius(15)
        .shadow(color: Color("blk").opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
    
    func progressBox(title: String, label: String) -> some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("blk"))
            Text(label)
                .font(.caption)
                .foregroundColor(Color("blk").opacity(0.6))
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView().environmentObject(WorkoutManager())
}
