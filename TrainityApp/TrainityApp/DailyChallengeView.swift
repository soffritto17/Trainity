import SwiftUI

// MARK: - Enum for difficulty levels
enum DifficultyLevel: String, CaseIterable, Codable {
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
    
    // Localized names
    var localizedName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
    
    // Colors for each level
    var color: Color {
        switch self {
        case .easy: return Color("blk")
        case .medium: return Color(red: 0.9, green: 0.6, blue: 0.0)
        case .hard: return Color(red: 0.8, green: 0.2, blue: 0.2)
        }
    }
    
    // Rest times
    var restTime: Int {
        switch self {
        case .easy: return 30
        case .medium: return 20
        case .hard: return 15
        }
    }
}

struct DailyChallengeView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingChallengeDetails = false
    @State private var showingLevelUpTips = false
    
    // Use enum instead of string for level
    @AppStorage("selectedDifficultyLevel") private var selectedDifficultyLevelRaw: String = DifficultyLevel.easy.rawValue
    @AppStorage("currentChallengeIndex") private var currentChallengeIndex: Int = 0
    @AppStorage("completedChallengesCount") private var completedChallengesCount: Int = 0
    @AppStorage("lastChallengeDate") private var lastChallengeDate: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    
    // Computed property for current level
    private var selectedDifficultyLevel: DifficultyLevel {
        get {
            return DifficultyLevel(rawValue: selectedDifficultyLevelRaw) ?? .easy
        }
        set {
            selectedDifficultyLevelRaw = newValue.rawValue
        }
    }
    
    // Calculate how many days have been completed in the current week
    private var completedDays: Int {
        workoutManager.dailyChallengeCompleted.filter { $0 }.count
    }
    
    // Generate four different workouts for each difficulty level
    private var challenges: [DifficultyLevel: [DailyChallenge]] {
        [
            .easy: [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Wall Push-ups", sets: 2, reps: 8),
                        Exercise(name: "Squats", sets: 2, reps: 8),
                        Exercise(name: "Push Ups", sets: 2, reps: 6)
                    ],
                    difficulty: DifficultyLevel.easy.localizedName,
                    description: "A light workout to start the day with energy!",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "High Knees", sets: 2, reps: 20),
                        Exercise(name: "Glute Bridges", sets: 3, reps: 12),
                        Exercise(name: "Plank", sets: 2, reps: 20) // seconds
                    ],
                    difficulty: DifficultyLevel.easy.localizedName,
                    description: "A simple workout to improve basic endurance.",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Arm Circles", sets: 2, reps: 15),
                        Exercise(name: "Walking Lunges", sets: 2, reps: 10),
                        Exercise(name: "Wall Sit", sets: 2, reps: 20) // seconds
                    ],
                    difficulty: DifficultyLevel.easy.localizedName,
                    description: "Focus on proper form to maximize benefits.",
                    estimatedTime: 15
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Side Lunges", sets: 2, reps: 8),
                        Exercise(name: "Seated Leg Raises", sets: 3, reps: 10),
                        Exercise(name: "Modified Push Ups", sets: 2, reps: 8)
                    ],
                    difficulty: DifficultyLevel.easy.localizedName,
                    description: "A complete low-intensity full-body workout.",
                    estimatedTime: 15
                )
            ],
            .medium: [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Burpees", sets: 3, reps: 10),
                        Exercise(name: "Lunges", sets: 3, reps: 12),
                        Exercise(name: "Mountain Climbers", sets: 3, reps: 20),
                        Exercise(name: "Plank", sets: 3, reps: 30) // seconds
                    ],
                    difficulty: DifficultyLevel.medium.localizedName,
                    description: "A medium-intensity workout to improve strength and endurance.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Jump Squats", sets: 3, reps: 15),
                        Exercise(name: "Push Up with Rotation", sets: 3, reps: 8),
                        Exercise(name: "Bicycle Crunches", sets: 3, reps: 20),
                        Exercise(name: "Russian Twists", sets: 3, reps: 15)
                    ],
                    difficulty: DifficultyLevel.medium.localizedName,
                    description: "Work on core and trunk strength in this challenge.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Lateral Shuffle", sets: 3, reps: 20),
                        Exercise(name: "Walking Planks", sets: 3, reps: 10),
                        Exercise(name: "Curtsy Lunges", sets: 3, reps: 12),
                        Exercise(name: "Tricep Dips", sets: 3, reps: 12)
                    ],
                    difficulty: DifficultyLevel.medium.localizedName,
                    description: "Improve mobility and strength with this circuit.",
                    estimatedTime: 25
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Side Plank", sets: 3, reps: 20), // seconds per side
                        Exercise(name: "Donkey Kicks", sets: 3, reps: 15),
                        Exercise(name: "Shoulder Taps", sets: 3, reps: 16),
                        Exercise(name: "Flutter Kicks", sets: 3, reps: 30)
                    ],
                    difficulty: DifficultyLevel.medium.localizedName,
                    description: "Focus on stabilization and core with this workout.",
                    estimatedTime: 25
                )
            ],
            .hard: [
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Burpees", sets: 4, reps: 15),
                        Exercise(name: "Jump Squats", sets: 4, reps: 20),
                        Exercise(name: "Push Up with Rotation", sets: 4, reps: 12),
                        Exercise(name: "Mountain Climbers", sets: 4, reps: 30),
                        Exercise(name: "Plank with Shoulder Tap", sets: 3, reps: 40) // seconds
                    ],
                    difficulty: DifficultyLevel.hard.localizedName,
                    description: "An intense challenge for experienced athletes!",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Jumping Lunges", sets: 4, reps: 20),
                        Exercise(name: "Burpee Push-ups", sets: 3, reps: 12),
                        Exercise(name: "Plank Jacks", sets: 4, reps: 25),
                        Exercise(name: "V-Ups", sets: 4, reps: 15),
                        Exercise(name: "Alternating Superman", sets: 3, reps: 20)
                    ],
                    difficulty: DifficultyLevel.hard.localizedName,
                    description: "A high-intensity workout to maximize conditioning.",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Diamond Push-ups", sets: 3, reps: 15),
                        Exercise(name: "Pistol Squats", sets: 3, reps: 8),
                        Exercise(name: "Tuck Jumps", sets: 4, reps: 15),
                        Exercise(name: "Dragon Flags", sets: 3, reps: 10),
                        Exercise(name: "Hollow Body Holds", sets: 3, reps: 45) // seconds
                    ],
                    difficulty: DifficultyLevel.hard.localizedName,
                    description: "This challenge will test your strength and endurance.",
                    estimatedTime: 35
                ),
                DailyChallenge(
                    exercises: [
                        Exercise(name: "Handstand Push-ups", sets: 3, reps: 8),
                        Exercise(name: "Box Jumps", sets: 4, reps: 15),
                        Exercise(name: "Wide Push-ups", sets: 4, reps: 15),
                        Exercise(name: "Single Leg Burpees", sets: 3, reps: 10),
                        Exercise(name: "L-Sit Hold", sets: 3, reps: 30) // seconds
                    ],
                    difficulty: DifficultyLevel.hard.localizedName,
                    description: "An advanced workout requiring strength and body control.",
                    estimatedTime: 35
                )
            ]
        ]
    }
    
    // Get current challenge
    private var currentChallenge: DailyChallenge? {
        guard let challengesForLevel = challenges[selectedDifficultyLevel] else { return nil }
        return challengesForLevel[currentChallengeIndex % challengesForLevel.count]
    }
    
    // Check if user is ready to advance to next level
    private var readyForNextLevel: Bool {
        if selectedDifficultyLevel == .hard { return false }
        return completedChallengesCount >= 8
    }
    
    // Determine next difficulty level
    private var nextLevel: DifficultyLevel {
        switch selectedDifficultyLevel {
        case .easy: return .medium
        case .medium: return .hard
        case .hard: return .hard
        }
    }
    
    var body: some View {
        ZStack {
            Color("wht").edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25) {
                // Header with icon
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color("blk"))
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        
                        Image(systemName: "figure.walk")
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(Color("wht"))
                    }
                    
                    Text("Daily Challenge")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                }
                .padding(.top, 10)
                
                // Weekly progress
                VStack(spacing: 12) {
                    HStack(spacing: 12) {
                        let weekdays = ["M", "T", "W", "T", "F", "S", "S"]
                        // Correct calculation: Monday=0, Tuesday=1, ..., Sunday=6
                        let todayWeekday = Calendar.current.component(.weekday, from: Date()) // 1=Sun, 2=Mon, ..., 7=Sat
                        let todayIndex = todayWeekday == 1 ? 6 : todayWeekday - 2 // Convert to 0-6 with Mon=0
                        
                        ForEach(0..<7) { day in
                            ZStack {
                                Circle()
                                    .fill(day == todayIndex ? Color("blk") : Color("wht"))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                day == todayIndex ? Color("blk") : Color("blk").opacity(0.3),
                                                lineWidth: day == todayIndex ? 2.5 : 1.5
                                            )
                                    )
                                    .shadow(
                                        color: day == todayIndex ? .black.opacity(0.15) : .black.opacity(0.08),
                                        radius: day == todayIndex ? 4 : 2,
                                        x: 0,
                                        y: day == todayIndex ? 2 : 1
                                    )
                                
                                if workoutManager.dailyChallengeCompleted[day] {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(day == todayIndex ? Color("wht") : Color("blk"))
                                } else {
                                    Text(weekdays[day])
                                        .foregroundColor(day == todayIndex ? Color("wht") : Color("blk"))
                                        .font(.system(size: 14, weight: day == todayIndex ? .semibold : .medium))
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 4) {
                        Text("\(completedDays) / 7 days completed")
                            .font(.subheadline)
                            .foregroundColor(Color("blk").opacity(0.7))
                        
                        if completedDays > 0 {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.orange)
                        }
                    }
                }
                
                // Level section with improved badge
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Level")
                            .font(.subheadline)
                            .foregroundColor(Color("blk").opacity(0.7))
                        
                        HStack(spacing: 8) {
                            Text(selectedDifficultyLevel.localizedName)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedDifficultyLevel.color)
                            
                            Circle()
                                .fill(selectedDifficultyLevel.color)
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                    
                    if readyForNextLevel {
                        Button(action: {
                            showingLevelUpTips = true
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 16))
                                Text("Level Up")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color("wht"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(nextLevel.color)
                            .cornerRadius(20)
                            .shadow(color: nextLevel.color.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Today's workout card
                if let challenge = currentChallenge {
                    VStack(spacing: 0) {
                        // Card header
                        VStack(spacing: 8) {
                            HStack {
                                Text("Today's Workout")
                                    .font(.headline)
                                    .foregroundColor(Color("blk"))
                                
                                Spacer()
                                
                                Text("\(challenge.estimatedTime) min")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(selectedDifficultyLevel.color)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(selectedDifficultyLevel.color.opacity(0.15))
                                    .cornerRadius(12)
                            }
                            
                            Text(challenge.description)
                                .font(.subheadline)
                                .foregroundColor(Color("blk").opacity(0.8))
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding()
                        .background(Color("wht"))
                        
                        Divider()
                            .background(Color("blk").opacity(0.1))
                        
                        // Exercise list
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(challenge.exercises.enumerated()), id: \.element.id) { index, exercise in
                                    HStack(spacing: 12) {
                                        // Exercise number
                                        ZStack {
                                            Circle()
                                                .fill(Color("blk").opacity(0.1))
                                                .frame(width: 28, height: 28)
                                            
                                            Text("\(index + 1)")
                                                .font(.caption)
                                                .fontWeight(.semibold)
                                                .foregroundColor(Color("blk"))
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(exercise.name)
                                                .font(.body)
                                                .fontWeight(.medium)
                                                .foregroundColor(Color("blk"))
                                            
                                            Text("\(exercise.sets) sets × \(exercise.reps) reps")
                                                .font(.caption)
                                                .foregroundColor(Color("blk").opacity(0.6))
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.vertical, 12)
                                    .padding(.horizontal)
                                    
                                    if index < challenge.exercises.count - 1 {
                                        Divider()
                                            .background(Color("blk").opacity(0.05))
                                            .padding(.leading, 52)
                                    }
                                }
                            }
                        }
                        .frame(maxHeight: 200)
                        .background(Color("wht"))
                    }
                    .background(Color("wht"))
                    .cornerRadius(15)
                    .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                    .padding(.horizontal)
                    
                    // Action buttons
                    HStack(spacing: 15) {
                        Menu {
                            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                                Button(action: {
                                    changeDifficultyLevel(to: level)
                                }) {
                                    HStack {
                                        Text(level.localizedName)
                                        if selectedDifficultyLevel == level {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "slider.horizontal.3")
                                    .font(.system(size: 16))
                                Text("Change Level")
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(Color("blk"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color("wht"))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
                        }
                        
                        Button(action: {
                            completeCurrentChallenge(challenge)
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16))
                                Text("Complete")
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(Color("wht"))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color("blk"))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            // Level up overlay
            if showingLevelUpTips {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        showingLevelUpTips = false
                    }
                
                VStack(spacing: 20) {
                    Text("You're ready for the next level!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color("blk"))
                    
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(nextLevel.color)
                    
                    Text("You've completed \(completedChallengesCount) challenges at \(selectedDifficultyLevel.localizedName) level. Your body and mind have adapted and now you can move to \(nextLevel.localizedName) level!")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("blk"))
                        .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("What awaits you at \(nextLevel.localizedName) level:")
                            .font(.headline)
                            .foregroundColor(Color("blk"))
                        
                        HStack {
                            Image(systemName: "flame.fill")
                                .foregroundColor(nextLevel.color)
                            Text("Higher intensity")
                        }
                        
                        HStack {
                            Image(systemName: "stopwatch.fill")
                                .foregroundColor(nextLevel.color)
                            Text("Longer workouts")
                        }
                        
                        HStack {
                            Image(systemName: "figure.strengthtraining.traditional")
                                .foregroundColor(nextLevel.color)
                            Text("More exercises per session")
                        }
                    }
                    .padding()
                    .background(Color("wht"))
                    .cornerRadius(10)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showingLevelUpTips = false
                        }) {
                            Text("Not Yet")
                                .font(.headline)
                                .foregroundColor(Color("blk"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("wht"))
                                .cornerRadius(10)
                                .shadow(radius: 1)
                        }
                        
                        Button(action: {
                            changeDifficultyLevel(to: nextLevel)
                            showingLevelUpTips = false
                        }) {
                            Text("Level Up")
                                .font(.headline)
                                .foregroundColor(Color("wht"))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(nextLevel.color)
                                .cornerRadius(10)
                                .shadow(radius: 1)
                        }
                    }
                }
                .padding()
                .background(Color("wht"))
                .cornerRadius(15)
                .shadow(radius: 10)
                .padding(.horizontal, 30)
                .transition(.scale)
            }
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("blk"))
            }
        )
        .onAppear {
            // TEMPORARY RESET - Remove after testing
            // resetAllData()
            // workoutManager.dailyChallengeCompleted[0] = true
            // workoutManager.dailyChallengeCompleted[1] = true
            
            checkForNewDay()
            checkForNewWeek()
        }
    }
    
    // Change difficulty level
    private func changeDifficultyLevel(to level: DifficultyLevel) {
        selectedDifficultyLevelRaw = level.rawValue
        if level != .easy {
            completedChallengesCount = 0
        }
    }
    
    // Complete current challenge
    private func completeCurrentChallenge(_ challenge: DailyChallenge) {
        // Correct calculation of weekday (same as display)
        let todayWeekday = Calendar.current.component(.weekday, from: Date()) // 1=Sun, 2=Mon, ..., 7=Sat
        let todayIndex = todayWeekday == 1 ? 6 : todayWeekday - 2 // Convert to 0-6 with Mon=0
        print("Today index: \(todayIndex)")
        workoutManager.dailyChallengeCompleted[todayIndex] = true
        completedChallengesCount += 1
        lastChallengeDate = Date()
        currentChallengeIndex = (currentChallengeIndex + 1) % 4
        
        let workout = Workout(
            name: "Daily Challenge - \(selectedDifficultyLevel.localizedName)",
            exercises: challenge.exercises,
            restTime: selectedDifficultyLevel.restTime
        )

        workoutManager.completeWorkout(workout)
    }
    
    // TEMPORARY RESET FUNCTION - Remove after testing
    private func resetAllData() {
        // Clear all UserDefaults
        UserDefaults.standard.removeObject(forKey: "lastWeekStart")
        UserDefaults.standard.removeObject(forKey: "selectedDifficultyLevel")
        UserDefaults.standard.removeObject(forKey: "currentChallengeIndex")
        UserDefaults.standard.removeObject(forKey: "completedChallengesCount")
        UserDefaults.standard.removeObject(forKey: "lastChallengeDate")
        UserDefaults.standard.removeObject(forKey: "WorkoutManagerData")
        
        do {
            let data = try JSONEncoder().encode(WorkoutManager())
            UserDefaults.standard.set(data, forKey: "WorkoutManagerData")
            print("Data saved successfully")
        } catch {
            print("Error saving data: \(error)")
        }
        
        // Reset completion array
        workoutManager.dailyChallengeCompleted = Array(repeating: false, count: 7)
        
        // Reset @AppStorage variables (force them to default values)
        selectedDifficultyLevelRaw = DifficultyLevel.easy.rawValue
        currentChallengeIndex = 0
        completedChallengesCount = 0
        lastChallengeDate = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        
        print("🔄 COMPLETE RESET PERFORMED")
    }
    
    // Check for new day
    private func checkForNewDay() {
        let calendar = Calendar.current
        if !calendar.isDate(lastChallengeDate, inSameDayAs: Date()) {
            // Rotation only if challenge completed
        }
    }
    
    // Check for new week and reset if necessary
    private func checkForNewWeek() {
        let calendar = Calendar.current
        let today = Date()
        
        // Get start of current week (Monday)
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = weekday == 1 ? 6 : weekday - 2 // Sunday = 6 days from Monday
        
        guard let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else { return }
        guard let startOfWeekNormalized = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: startOfWeek) else { return }
        
        // Check if it's a new week compared to last time
        if let lastWeekStart = getLastWeekStart() {
            if !calendar.isDate(lastWeekStart, inSameDayAs: startOfWeekNormalized) {
                // New week - reset all completions
                workoutManager.dailyChallengeCompleted = Array(repeating: false, count: 7)
                setLastWeekStart(startOfWeekNormalized)
            }
        } else {
            // First time - save current week start
            setLastWeekStart(startOfWeekNormalized)
        }
    }
    
    // Helper functions to save/retrieve last week start
    private func getLastWeekStart() -> Date? {
        return UserDefaults.standard.object(forKey: "lastWeekStart") as? Date
    }
    
    private func setLastWeekStart(_ date: Date) {
        UserDefaults.standard.set(date, forKey: "lastWeekStart")
    }
}

struct DailyChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DailyChallengeView()
                .environmentObject(WorkoutManager())
        }
    }
}

