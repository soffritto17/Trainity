import SwiftUI

struct HomeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    
    let motivationalQuotes = [
        "Il fitness è come una relazione. Devi rimanerci fedele perché funzioni.",
        "La forza non viene da ciò che puoi fare. Viene dal superare ciò che pensavi di non poter fare.",
        "Ci vuole un po' più di forza per fare un altro passo in avanti.",
        "Il cambiamento avviene quando l'impegno supera la resistenza.",
        "Il miglior progetto su cui puoi lavorare sei tu stesso.",
        "Più sudi in allenamento, meno sanguini in battaglia.",
        "Credi in te stesso e sarai inarrestabile.",
        "La fatica dura un'ora. L'orgoglio dura per sempre.",
        "Nessun dolore, nessun guadagno. Nessun sforzo, nessun risultato.",
        "La costanza è più importante della perfezione.",
        "Il tuo corpo può sopportare quasi tutto. È la tua mente che devi convincere.",
        "Investi in te stesso. È il miglior investimento che farai mai.",
        "Non aspettare. Il momento non sarà mai perfetto.",
        "Gli ostacoli sono quelle cose spaventose che vedi quando togli gli occhi dal tuo obiettivo.",
        "Rendi il tuo corpo l'arma più forte, non la tua debolezza."
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
