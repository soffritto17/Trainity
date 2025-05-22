import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var editingNickname = false
    @State private var newNickname = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("wht").edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 25) {
                        profileHeaderView
                        badgesSectionView
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitle("Profilo", displayMode: .inline)
        }
    }
    
    private var profileHeaderView: some View {
        VStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(Color("blk"))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color("blk").opacity(0.1), radius: 4, x: 0, y: 2)
                
                Text(String(workoutManager.nickname.prefix(1)))
                    .font(.system(size: 46, weight: .bold))
                    .foregroundColor(Color("wht"))
            }
            .padding(.top, 10)
            
            if editingNickname {
                HStack {
                    TextField("Nickname", text: $newNickname)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding(8)
                        .background(Color("wht"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("blk").opacity(0.2), lineWidth: 1)
                        )
                    
                    Button(action: saveNickname) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("blk"))
                    }
                    
                    Button(action: cancelEditing) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundColor(Color("blk").opacity(0.6))
                    }
                }
                .padding(.horizontal, 50)
            } else {
                HStack {
                    Text(workoutManager.nickname)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                    
                    Button(action: startEditing) {
                        Image(systemName: "square.and.pencil")
                            .font(.body)
                            .foregroundColor(Color("blk"))
                    }
                }
            }
            
            // MODIFICA: HStack con Spacer per distribuzione equa
            HStack {
                Spacer()
                statItem(value: "\(workoutManager.totalWorkoutsCompleted)", label: "Allenamenti", icon: "figure.run")
                Spacer()
                statItem(value: "\(workoutManager.badgesEarned)", label: "Badge", icon: "trophy.fill")
                Spacer()
                statItem(value: "\(workoutManager.weeklyStreak)", label: "Streak", icon: "flame.fill")
                Spacer()
            }
            .padding()
            
            Rectangle()
                .fill(Color("blk").opacity(0.1))
                .frame(height: 1)
                .padding(.horizontal)
            
            // MODIFICA: Layout semplificato e centrato per "Sfide completate"
            VStack {
                Text("\(workoutManager.dailyChallengeCompleted.filter { $0 }.count)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("blk"))
                Text("Sfide completate")
                    .font(.caption)
                    .foregroundColor(Color("blk").opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("wht"))
                .shadow(color: Color("blk").opacity(0.05), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
    }
    
    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(Color("blk"))
                .frame(width: 24, height: 24) // Dimensione fissa per le icone
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Color("blk"))
            Text(label)
                .font(.caption)
                .foregroundColor(Color("blk").opacity(0.6))
                .multilineTextAlignment(.center)
        }
        .frame(minWidth: 80) // Larghezza minima per ogni elemento
    }
    
    private var badgesSectionView: some View {
        VStack(alignment: .leading) {
            Text("I tuoi Badge")
                .font(.headline)
                .foregroundColor(Color("blk"))
                .padding(.horizontal)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(workoutManager.badges) { badge in
                    badgeView(badge: badge)
                }
            }
            .padding(.horizontal)
        }
    }
    
    private func badgeView(badge: Badge) -> some View {
        VStack(spacing: 5) {
            ZStack {
                Circle()
                    .fill(badge.isEarned ? Color("blk") : Color("blk").opacity(0.1))
                    .frame(width: 70, height: 70)
                
                if !badge.isEarned {
                    Image(systemName: "lock.fill")
                        .foregroundColor(Color("blk").opacity(0.4))
                        .font(.system(size: 24))
                } else {
                    Image(systemName: badge.imageName)
                        .font(.system(size: 30))
                        .foregroundColor(Color("wht"))
                }
            }
            
            Text(badge.name)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(badge.isEarned ? Color("blk") : Color("blk").opacity(0.6))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Text(badge.description)
                .font(.caption2)
                .foregroundColor(Color("blk").opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .frame(height: 25)
        }
        .padding(.vertical, 5)
    }
    
    // MARK: - Funzioni per gestire la modifica del nickname
    
    private func startEditing() {
        newNickname = workoutManager.nickname
        editingNickname = true
    }
    
    private func saveNickname() {
        let trimmedNickname = newNickname.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedNickname.isEmpty {
            workoutManager.updateNickname(trimmedNickname)
            print("Nickname salvato: \(trimmedNickname)")
        }
        
        editingNickname = false
    }
    
    private func cancelEditing() {
        newNickname = workoutManager.nickname // Ripristina il valore originale
        editingNickname = false
    }
}

#Preview {
    ProfileView()
        .environmentObject(WorkoutManager())
}
