import SwiftUI

@main
struct TrainityApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// MODELLI DI DATI
struct Exercise: Identifiable, Codable {
    var id = UUID()
    var name: String
    var sets: Int
    var reps: Int
    var weight: Double?
    var isCompleted: Bool = false
    
    // Nuovi campi per salvare i dati effettivi per ogni serie
    var actualReps: [Int]? // Ripetizioni effettive per ogni serie
    var actualWeights: [Double?]? // Pesi effettivi per ogni serie
}

struct DailyChallenge: Codable {
    var exercises: [Exercise]
    var difficulty: String
    var description: String
    var estimatedTime: Int // in minuti
}

struct Workout: Identifiable,Codable{
    var id = UUID()
    var name: String
    
    var exercises: [Exercise]
    
    var restTime: Int // in secondi
    
}

struct WorkoutRecord: Identifiable,Codable {
    var id = UUID()
    var workout: Workout
    var date: Date
    
    var completed: Bool
    var caloriesBurned: Int = 0
}

struct Badge: Identifiable,Codable{
    var id: String
    var name: String
    var description: String
    var imageName: String
    var isEarned: Bool = false
}

class WorkoutManager: ObservableObject, Codable {
    // Proprietà pubblicate
    @Published var dailyChallengeCompleted = [false, false, false, false, false, false, false]
    @Published var savedWorkouts: [Workout] = []
    @Published var workoutHistory: [WorkoutRecord] = []
    @Published var nickname: String = "Atleta"
    @Published var totalWorkoutsCompleted: Int = 0
    @Published var weeklyStreak: Int = 1
    @Published var badgesEarned: Int = 0
    @Published var badges: [Badge] = []
    
    // Proprietà per tracciare le statistiche per i badge
    @Published var totalCaloriesBurned: Int = 0
    @Published var totalWorkoutMinutes: Int = 0
    @Published var activeWorkoutDays: Int = 0
    
    // Nuove proprietà per tracciare il tempo effettivo dell'allenamento
    @Published var currentWorkoutStartTime: Date?
    @Published var isWorkoutActive: Bool = false
    
    // Contatori specifici per i badge
    private var morningWorkoutsCompleted: Int = 0    // Allenamenti mattutini
    private var eveningWorkoutsCompleted: Int = 0    // Allenamenti serali
    private var weekendWorkoutsCompleted: Int = 0    // Allenamenti nei weekend
    private var longWorkoutsCompleted: Int = 0       // Allenamenti lunghi (>30 min)
    private var dailyChallengesCompleted: Int = 0    // Sfide giornaliere completate
    private var differentDaysWithWorkouts: Int = 0   // Diversi giorni con allenamenti
    private var consecutiveDaysStreak: Int = 0       // Giorni consecutivi di allenamento
    
    // Proprietà per evitare duplicati
    private var lastWorkoutCompletionTime: Date? = nil
    
    // MARK: - Codable Implementation
    
    enum CodingKeys: String, CodingKey {
        case dailyChallengeCompleted
        case savedWorkouts
        case workoutHistory
        case nickname
        case totalWorkoutsCompleted
        case weeklyStreak
        case badgesEarned
        case badges
        case totalCaloriesBurned
        case totalWorkoutMinutes
        case activeWorkoutDays
        case currentWorkoutStartTime
        case isWorkoutActive
        case morningWorkoutsCompleted
        case eveningWorkoutsCompleted
        case weekendWorkoutsCompleted
        case longWorkoutsCompleted
        case dailyChallengesCompleted
        case differentDaysWithWorkouts
        case consecutiveDaysStreak
        case lastWorkoutCompletionTime
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decodifica tutte le proprietà
        let dailyChallengeCompleted = try container.decodeIfPresent([Bool].self, forKey: .dailyChallengeCompleted) ?? [false, false, false, false, false, false, false]
        let savedWorkouts = try container.decodeIfPresent([Workout].self, forKey: .savedWorkouts) ?? []
        let workoutHistory = try container.decodeIfPresent([WorkoutRecord].self, forKey: .workoutHistory) ?? []
        let nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? "Atleta"
        let totalWorkoutsCompleted = try container.decodeIfPresent(Int.self, forKey: .totalWorkoutsCompleted) ?? 0
        let weeklyStreak = try container.decodeIfPresent(Int.self, forKey: .weeklyStreak) ?? 1
        let badgesEarned = try container.decodeIfPresent(Int.self, forKey: .badgesEarned) ?? 0
        let badges = try container.decodeIfPresent([Badge].self, forKey: .badges) ?? []
        let totalCaloriesBurned = try container.decodeIfPresent(Int.self, forKey: .totalCaloriesBurned) ?? 0
        let totalWorkoutMinutes = try container.decodeIfPresent(Int.self, forKey: .totalWorkoutMinutes) ?? 0
        let activeWorkoutDays = try container.decodeIfPresent(Int.self, forKey: .activeWorkoutDays) ?? 0
        let currentWorkoutStartTime = try container.decodeIfPresent(Date.self, forKey: .currentWorkoutStartTime)
        let isWorkoutActive = try container.decodeIfPresent(Bool.self, forKey: .isWorkoutActive) ?? false
        
        // Proprietà private
        self.morningWorkoutsCompleted = try container.decodeIfPresent(Int.self, forKey: .morningWorkoutsCompleted) ?? 0
        self.eveningWorkoutsCompleted = try container.decodeIfPresent(Int.self, forKey: .eveningWorkoutsCompleted) ?? 0
        self.weekendWorkoutsCompleted = try container.decodeIfPresent(Int.self, forKey: .weekendWorkoutsCompleted) ?? 0
        self.longWorkoutsCompleted = try container.decodeIfPresent(Int.self, forKey: .longWorkoutsCompleted) ?? 0
        self.dailyChallengesCompleted = try container.decodeIfPresent(Int.self, forKey: .dailyChallengesCompleted) ?? 0
        self.differentDaysWithWorkouts = try container.decodeIfPresent(Int.self, forKey: .differentDaysWithWorkouts) ?? 0
        self.consecutiveDaysStreak = try container.decodeIfPresent(Int.self, forKey: .consecutiveDaysStreak) ?? 0
        self.lastWorkoutCompletionTime = try container.decodeIfPresent(Date.self, forKey: .lastWorkoutCompletionTime)
        
        // Assegna alle proprietà @Published
        self.dailyChallengeCompleted = dailyChallengeCompleted
        self.savedWorkouts = savedWorkouts
        self.workoutHistory = workoutHistory
        self.nickname = nickname
        self.totalWorkoutsCompleted = totalWorkoutsCompleted
        self.weeklyStreak = weeklyStreak
        self.badgesEarned = badgesEarned
        self.badges = badges.isEmpty ? createDefaultBadges() : badges
        self.totalCaloriesBurned = totalCaloriesBurned
        self.totalWorkoutMinutes = totalWorkoutMinutes
        self.activeWorkoutDays = activeWorkoutDays
        self.currentWorkoutStartTime = currentWorkoutStartTime
        self.isWorkoutActive = isWorkoutActive
        
        // Ricalcola le statistiche se necessario
        if badges.isEmpty {
            recalculateAllStats()
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        // Codifica tutte le proprietà @Published
        try container.encode(dailyChallengeCompleted, forKey: .dailyChallengeCompleted)
        try container.encode(savedWorkouts, forKey: .savedWorkouts)
        try container.encode(workoutHistory, forKey: .workoutHistory)
        try container.encode(nickname, forKey: .nickname)
        try container.encode(totalWorkoutsCompleted, forKey: .totalWorkoutsCompleted)
        try container.encode(weeklyStreak, forKey: .weeklyStreak)
        try container.encode(badgesEarned, forKey: .badgesEarned)
        try container.encode(badges, forKey: .badges)
        try container.encode(totalCaloriesBurned, forKey: .totalCaloriesBurned)
        try container.encode(totalWorkoutMinutes, forKey: .totalWorkoutMinutes)
        try container.encode(activeWorkoutDays, forKey: .activeWorkoutDays)
        try container.encodeIfPresent(currentWorkoutStartTime, forKey: .currentWorkoutStartTime)
        try container.encode(isWorkoutActive, forKey: .isWorkoutActive)
        
        // Codifica le proprietà private
        try container.encode(morningWorkoutsCompleted, forKey: .morningWorkoutsCompleted)
        try container.encode(eveningWorkoutsCompleted, forKey: .eveningWorkoutsCompleted)
        try container.encode(weekendWorkoutsCompleted, forKey: .weekendWorkoutsCompleted)
        try container.encode(longWorkoutsCompleted, forKey: .longWorkoutsCompleted)
        try container.encode(dailyChallengesCompleted, forKey: .dailyChallengesCompleted)
        try container.encode(differentDaysWithWorkouts, forKey: .differentDaysWithWorkouts)
        try container.encode(consecutiveDaysStreak, forKey: .consecutiveDaysStreak)
        try container.encodeIfPresent(lastWorkoutCompletionTime, forKey: .lastWorkoutCompletionTime)
    }
    
    // MARK: - Initialization
    
    init() {
        loadData() // Carica i dati salvati
        badges = badges.isEmpty ? createDefaultBadges() : badges
        recalculateAllStats()
    }
    
    // MARK: - Data Persistence
    
    private func loadData() {
        if let data = UserDefaults.standard.data(forKey: "WorkoutManagerData") {
            do {
                let decodedManager = try JSONDecoder().decode(WorkoutManager.self, from: data)
                
                // Copia i dati caricati nelle proprietà @Published
                self.dailyChallengeCompleted = decodedManager.dailyChallengeCompleted
                self.savedWorkouts = decodedManager.savedWorkouts
                self.workoutHistory = decodedManager.workoutHistory
                self.nickname = decodedManager.nickname
                self.totalWorkoutsCompleted = decodedManager.totalWorkoutsCompleted
                self.weeklyStreak = decodedManager.weeklyStreak
                self.badgesEarned = decodedManager.badgesEarned
                self.badges = decodedManager.badges
                self.totalCaloriesBurned = decodedManager.totalCaloriesBurned
                self.totalWorkoutMinutes = decodedManager.totalWorkoutMinutes
                self.activeWorkoutDays = decodedManager.activeWorkoutDays
                self.currentWorkoutStartTime = decodedManager.currentWorkoutStartTime
                self.isWorkoutActive = decodedManager.isWorkoutActive
                
                // Copia anche le proprietà private
                self.morningWorkoutsCompleted = decodedManager.morningWorkoutsCompleted
                self.eveningWorkoutsCompleted = decodedManager.eveningWorkoutsCompleted
                self.weekendWorkoutsCompleted = decodedManager.weekendWorkoutsCompleted
                self.longWorkoutsCompleted = decodedManager.longWorkoutsCompleted
                self.dailyChallengesCompleted = decodedManager.dailyChallengesCompleted
                self.differentDaysWithWorkouts = decodedManager.differentDaysWithWorkouts
                self.consecutiveDaysStreak = decodedManager.consecutiveDaysStreak
                self.lastWorkoutCompletionTime = decodedManager.lastWorkoutCompletionTime
                
                print("Dati caricati con successo")
            } catch {
                print("Errore nel caricamento dei dati: \(error)")
                // Se il caricamento fallisce, usa valori di default
                badges = createDefaultBadges()
            }
        } else {
            // Prima volta che si apre l'app
            badges = createDefaultBadges()
            print("Nessun dato salvato trovato, inizializzazione con valori di default")
        }
    }
    
    private func saveData() {
        do {
            let data = try JSONEncoder().encode(self)
            UserDefaults.standard.set(data, forKey: "WorkoutManagerData")
            print("Dati salvati con successo")
        } catch {
            print("Errore nel salvataggio dei dati: \(error)")
        }
    }
    
    private func createDefaultBadges() -> [Badge] {
            return [
                // Existing badges
                Badge(id: "first_workout", name: "Beginner", description: "Complete your first workout", imageName: "star.fill"),
                Badge(id: "week_streak", name: "Determined", description: "Complete 5 workouts", imageName: "flame.fill"),
                Badge(id: "muscle_builder", name: "Expert", description: "Complete 20 workouts", imageName: "trophy.fill"),
                Badge(id: "constancy", name: "Consistency", description: "Complete workouts for 7 consecutive days", imageName: "figure.walk.motion"),
                Badge(id: "champion", name: "Champion", description: "Complete 30 total workouts", imageName: "trophy.fill"),
                
                // New badges
                Badge(id: "early_bird", name: "Early Bird", description: "Complete 5 workouts before 9:00 AM", imageName: "sunrise.fill"),
                Badge(id: "night_owl", name: "Night Owl", description: "Complete 5 workouts after 8:00 PM", imageName: "moon.stars.fill"),
                Badge(id: "weekend_warrior", name: "Weekend Warrior", description: "Complete 3 workouts during weekends", imageName: "figure.run"),
                Badge(id: "challenge_master", name: "Challenge Master", description: "Complete 5 daily challenges", imageName: "checkmark.seal.fill"),
                Badge(id: "variety", name: "Versatility", description: "Complete workouts on 5 different days of the week", imageName: "chart.bar.fill"),
                Badge(id: "exercise_master", name: "Exercise Master", description: "Complete 100 total exercises", imageName: "dumbbell.fill")
            ]
        }
    
    // MARK: - Stats and Badge Management
    
    // Calcola tutte le statistiche in base alla cronologia
    func recalculateAllStats() {
        totalWorkoutsCompleted = workoutHistory.count
        totalWorkoutMinutes = 0
        activeWorkoutDays = 0
        morningWorkoutsCompleted = 0
        eveningWorkoutsCompleted = 0
        weekendWorkoutsCompleted = 0
        longWorkoutsCompleted = 0
        
        // Reset del contatore per gli esercizi totali
        var totalExercisesCompleted = 0
        
        // Set per tenere traccia dei giorni della settimana con allenamenti
        var workoutDays = Set<String>()
        var workoutDaysOfWeek = Set<Int>()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        
        // Calcola la streak e le statistiche
        for record in workoutHistory {
            // Aggiungi durata
            
            
            // Aggiungi il giorno come attivo
            let dayString = dateFormatter.string(from: record.date)
            workoutDays.insert(dayString)
            
            // Controlla l'ora del giorno per gli allenamenti
            let hour = calendar.component(.hour, from: record.date)
            if hour < 9 {
                morningWorkoutsCompleted += 1
            } else if hour >= 20 {
                eveningWorkoutsCompleted += 1
            }
            
            // Controlla se è weekend
            let weekday = calendar.component(.weekday, from: record.date)
            workoutDaysOfWeek.insert(weekday)
            if weekday == 1 || weekday == 7 { // Domenica o Sabato
                weekendWorkoutsCompleted += 1
            }
            
            // Controlla la durata dell'allenamento
            
            
            // Conta gli esercizi completati
            if record.completed {
                totalExercisesCompleted += record.workout.exercises.count
            }
        }
        
        activeWorkoutDays = workoutDays.count
        differentDaysWithWorkouts = workoutDaysOfWeek.count
        
        // Calcola la streak di giorni consecutivi
        updateStreak()
        
        // Verifica tutti i badge dopo il ricalcolo
        checkAndAwardBadges(totalExercisesCompleted: totalExercisesCompleted)
    }
    
    // Aggiorna la streak di giorni consecutivi
    private func updateStreak() {
        // Implementazione per calcolare streak
        let calendar = Calendar.current
        
        // Ordina la cronologia per data
        let sortedHistory = workoutHistory.sorted { $0.date < $1.date }
        
        // Gestisci i casi speciali dove non ci sono abbastanza allenamenti
        if sortedHistory.isEmpty {
            consecutiveDaysStreak = 0
            weeklyStreak = 0
            return
        }
        
        if sortedHistory.count == 1 {
            consecutiveDaysStreak = 1
            weeklyStreak = 1
            return
        }
        
        // Trova giorni consecutivi
        var currentStreak = 1
        var maxStreak = 1
        
        // Solo ora iteriamo, sapendo che ci sono almeno 2 elementi
        for i in 1..<sortedHistory.count {
            let currentDate = calendar.startOfDay(for: sortedHistory[i].date)
            let previousDate = calendar.startOfDay(for: sortedHistory[i-1].date)
            
            // Calcola giorni di differenza
            if let days = calendar.dateComponents([.day], from: previousDate, to: currentDate).day {
                if days == 1 {
                    // Giorno consecutivo
                    currentStreak += 1
                } else if days > 1 {
                    // Streak interrotto
                    if currentStreak > maxStreak {
                        maxStreak = currentStreak
                    }
                    currentStreak = 1
                }
            }
        }
        
        // Aggiorna il massimo se necessario
        if currentStreak > maxStreak {
            maxStreak = currentStreak
        }
        
        consecutiveDaysStreak = maxStreak
        weeklyStreak = maxStreak // Per compatibilità
    }
    
    private func checkAndAwardBadges(totalExercisesCompleted: Int) {
        // Badge esistenti
        if totalWorkoutsCompleted >= 1 {
            awardBadge(withId: "first_workout")
        }
        
        if totalWorkoutsCompleted >= 5 {
            awardBadge(withId: "week_streak")
        }
        
        if totalWorkoutsCompleted >= 20 {
            awardBadge(withId: "muscle_builder")
        }
        
        if consecutiveDaysStreak >= 7 {
            awardBadge(withId: "constancy")
        }
        
        if totalWorkoutsCompleted >= 30 {
            awardBadge(withId: "champion")
        }
        
        // Nuovi badge
        if morningWorkoutsCompleted >= 5 {
            awardBadge(withId: "early_bird")
        }
        
        if eveningWorkoutsCompleted >= 5 {
            awardBadge(withId: "night_owl")
        }
        
        if weekendWorkoutsCompleted >= 3 {
            awardBadge(withId: "weekend_warrior")
        }
        
        if longWorkoutsCompleted >= 1 {
            awardBadge(withId: "marathon")
        }
        
        if dailyChallengesCompleted >= 5 {
            awardBadge(withId: "challenge_master")
        }
        
        if differentDaysWithWorkouts >= 5 {
            awardBadge(withId: "variety")
        }
        
        // Badge per ore totali di allenamento (10 ore = 600 minuti)
        if totalWorkoutMinutes >= 600 {
            awardBadge(withId: "dedication")
        }
        
        // Badge per esercizi totali completati
        if totalExercisesCompleted >= 100 {
            awardBadge(withId: "exercise_master")
        }
    }
    
    // Funzione per tracciare il completamento delle sfide giornaliere
    func completeDailyChallenge() {
        dailyChallengesCompleted += 1
        checkAndAwardBadges(totalExercisesCompleted: 0) // Controlla solo per il badge challenge_master
        saveData() // Salva dopo ogni completamento
    }
    
    func completeWorkout(_ workout: Workout) {
        // Verifica se è passato almeno 1 secondo dall'ultima registrazione
        // per evitare registrazioni duplicate accidentali
        let now = Date()
        if let lastTime = lastWorkoutCompletionTime,
           now.timeIntervalSince(lastTime) < 1.0 {
            print("Evitata registrazione duplicata per: \(workout.name)")
            return
        }
        
        // Aggiorna il timestamp dell'ultimo completamento
        lastWorkoutCompletionTime = now
        
        // Crea e aggiungi il nuovo record
        let record = WorkoutRecord(
            workout: workout,
            date: now,
            
            completed: true,
            caloriesBurned: 0
        )
       
        workoutHistory.append(record)
        
        // Aggiorna le statistiche
        recalculateAllStats()
        
        // Salva i dati aggiornati
        saveData()
        
        print("Workout completato: \(workout.name)")
    }
    
    // Funzione per salvare un nuovo workout
    func saveWorkout(_ workout: Workout) {
        savedWorkouts.append(workout)
        saveData()
        print("Workout salvato: \(workout.name)")
    }
    
    // Funzione per aggiornare il nickname
    func updateNickname(_ newNickname: String) {
        nickname = newNickname
        saveData()
    }
    
    // Funzione per completare una daily challenge
    func completeDailyChallenge(dayIndex: Int) {
        if dayIndex < dailyChallengeCompleted.count {
            dailyChallengeCompleted[dayIndex] = true
            dailyChallengesCompleted += 1
            checkAndAwardBadges(totalExercisesCompleted: 0)
            saveData()
        }
    }
    
    // Funzione per eliminare un workout dalla cronologia
    func deleteWorkoutRecord(at offsets: IndexSet) {
        // Ordina la cronologia per data (più recente prima) per mantenere coerenza con la vista
        let sortedHistory = workoutHistory.sorted { $0.date > $1.date }
        
        // Trova gli ID dei record da eliminare
        var idsToDelete: [UUID] = []
        for offset in offsets {
            if offset < sortedHistory.count {
                idsToDelete.append(sortedHistory[offset].id)
            }
        }
        
        // Rimuovi i record dalla cronologia originale
        workoutHistory.removeAll { record in
            idsToDelete.contains(record.id)
        }
        
        // Ricalcola le statistiche e salva
        recalculateAllStats()
        saveData()
        
        print("Eliminati \(idsToDelete.count) record dalla cronologia")
    }
    
    // Funzione per eliminare un singolo workout record per ID
    func deleteWorkoutRecord(withId id: UUID) {
        workoutHistory.removeAll { $0.id == id }
        recalculateAllStats()
        saveData()
        print("Record eliminato dalla cronologia")
    }
    
    // Funzione di utilità per assegnare un badge specifico
    private func awardBadge(withId id: String) {
        if let index = badges.firstIndex(where: { $0.id == id && !$0.isEarned }) {
            badges[index].isEarned = true
            badgesEarned += 1
            
            // Qui potresti aggiungere codice per notifiche/animazioni
            print("Badge guadagnato: \(badges[index].name)")
        }
    }
}
