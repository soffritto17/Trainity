import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var editingNickname = false
    @State private var newNickname = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.95, green: 0.97, blue: 0.97).edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        // Profilo header
                        profileHeaderView
                        
                        // Sezione badge
                        badgesSectionView
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitle("Profilo", displayMode: .inline)
        }
    }
    
    // Header del profilo con avatar e statistiche
    private var profileHeaderView: some View {
        VStack(spacing: 15) {
            // Avatar e nickname
            ZStack {
                Circle()
                    .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Text(String(workoutManager.nickname.prefix(1)))
                    .font(.system(size: 46, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
            
            // Nickname con opzione di modifica
            if editingNickname {
                HStack {
                    TextField("Nickname", text: $newNickname)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                    
                    Button(action: {
                        if !newNickname.isEmpty {
                            workoutManager.nickname = newNickname
                        }
                        editingNickname = false
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    }
                }
                .padding(.horizontal, 50)
            } else {
                HStack {
                    Text(workoutManager.nickname)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Button(action: {
                        newNickname = workoutManager.nickname
                        editingNickname = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.body)
                            .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    }
                }
            }
            
            // Statistiche principali
            HStack(spacing: 40) {
                statItem(value: "\(workoutManager.totalWorkoutsCompleted)", label: "Allenamenti", icon: "figure.run")
                
                statItem(value: "\(workoutManager.badgesEarned)", label: "Badge", icon: "trophy.fill")
                
                statItem(value: "\(workoutManager.weeklyStreak)", label: "Streak", icon: "flame.fill")
            }
            .padding()
            
            // Linea divisoria
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal)
            
                            // Statistiche secondarie - MODIFICATO
            HStack(spacing: 0) {
                // Statistiche allenamenti totali
              
            
                
                // Aggiunto divisore verticale
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 1, height: 30)
                
                // Statistiche sfide giornaliere
                VStack {
                    Text("\(workoutManager.dailyChallengeCompleted.filter { $0 }.count)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    Text("Sfide completate")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    // Funzione per creare un elemento statistico con icona
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
    
    // Vista della sezione badge
    private var badgesSectionView: some View {
        VStack(alignment: .leading) {
            Text("I tuoi Badge")
                .font(.headline)
                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(workoutManager.badges) { badge in
                    badgeView(badge: badge)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // Vista di un singolo badge
    private func badgeView(badge: Badge) -> some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(badge.isEarned ? Color(red: 0.1, green: 0.4, blue: 0.4) : Color.gray.opacity(0.2))
                    .frame(width: 70, height: 70)
                
                if !badge.isEarned {
                    Image(systemName: "lock.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
                } else {
                    Image(systemName: badge.imageName)
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            
            Text(badge.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(badge.isEarned ? Color(red: 0.1, green: 0.4, blue: 0.4) : .gray)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            // Mostro la descrizione del badge
            
                Text(badge.description)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .frame(height: 25)

        }
        .padding(.vertical, 5)
    }
}

#Preview {
    ProfileView()
        .environmentObject(WorkoutManager())
}
