import SwiftUI
import AudioToolbox
import AVFoundation

struct ActiveWorkoutView: View {
    let workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme // Aggiunto per rilevare dark mode
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var completedSets: [String: [Int]] = [:]
    @State private var exerciseWeights: [String: [Double?]] = [:] // Modificato: ora traccia array di pesi per ogni esercizio
    @State private var currentExerciseIndex = 0
    @State private var showingCompletionAlert = false
    @State private var showingTimerSheet = false
    @State private var timeRemaining: Int = 60
    @State private var isTimerRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil
    
    // Colori dinamici basati su dark mode
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.black : Color("wht")
    }
    
    private var textColor: Color {
        colorScheme == .dark ? Color.white : Color("blk")
    }
    
    private var accentColor: Color {
        Color("blk") // Questo si adatterà automaticamente alla dark mode se definito correttamente
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color.gray.opacity(0.2) : Color("wht")
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.1) : Color("blk").opacity(0.1)
    }
    
    var body: some View {
        ZStack {
            backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                Text("Workout: \(workout.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .padding(.top, 20)
                
                // Progress indicator
                ProgressView(value: Double(currentExerciseIndex), total: Double(workout.exercises.count))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .tint(accentColor)
                
                Text("\(currentExerciseIndex)/\(workout.exercises.count) exercises completed")
                    .font(.subheadline)
                    .foregroundColor(textColor.opacity(0.7))
                    .padding(.top, 5)
                
                // Exercise list
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(0..<workout.exercises.count, id: \.self) { index in
                            let exercise = workout.exercises[index]
                            
                            ExerciseTrackingCard(
                                exercise: exercise,
                                isActive: index == currentExerciseIndex,
                                isCompleted: index < currentExerciseIndex,
                                completedReps: completedSets[exercise.id.uuidString] ?? Array(repeating: 0, count: exercise.sets),
                                onSetComplete: { setIndex, reps in
                                    // Salva le ripetizioni completate
                                    var exerciseSets = completedSets[exercise.id.uuidString] ?? Array(repeating: 0, count: exercise.sets)
                                    exerciseSets[setIndex] = reps
                                    completedSets[exercise.id.uuidString] = exerciseSets
                                    
                                    // Se tutte le serie sono completate, passa all'esercizio successivo
                                    let allSetsCompleted = exerciseSets.allSatisfy { $0 > 0 }
                                    if allSetsCompleted && setIndex == exercise.sets - 1 {
                                        if index < workout.exercises.count - 1 {
                                            currentExerciseIndex = index + 1
                                        } else {
                                            showingCompletionAlert = true
                                        }
                                    }
                                },
                                onWeightUpdate: { weights in
                                    // NUOVO: Salva i pesi per ogni serie dell'esercizio
                                    exerciseWeights[exercise.id.uuidString] = weights
                                    print("Pesi aggiornati per \(exercise.name): \(weights)")
                                }
                            )
                            .padding(.horizontal)
                        }
                        
                        // Spazio extra in fondo
                        Spacer().frame(height: 80)
                    }
                }
                
                // Mini timer display draggable
                VStack {
                    Divider()
                        .background(accentColor.opacity(0.3))
                    
                    Button(action: {
                        showingTimerSheet = true
                    }) {
                        HStack {
                            // Play/Pause button
                            Button(action: {
                                toggleTimer()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                        .font(.title2)
                                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                                }
                            }
                            .padding(.trailing, 10)
                            
                            // Timer display
                            VStack(alignment: .leading) {
                                Text("Rest Timer")
                                    .font(.subheadline)
                                    .foregroundColor(textColor)
                                
                                Text("\(timeRemaining) seconds")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(textColor)
                            }
                            
                            Spacer()
                            
                            // Drag indicator
                            Image(systemName: "chevron.up")
                                .foregroundColor(textColor)
                                .padding(.trailing)
                        }
                        .padding()
                        .background(cardBackgroundColor)
                        .cornerRadius(15)
                        .shadow(color: shadowColor, radius: 5, x: 0, y: 2)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(backgroundColor)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button(action: {
                // Ferma il timer se è in esecuzione
                timer?.invalidate()
                timer = nil
                
                // Salva l'allenamento nella cronologia solo se almeno un esercizio è stato completato
                if currentExerciseIndex > 0 || !completedSets.isEmpty {
                    saveWorkoutToHistory()
                }
                
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("End")
                    .font(.headline)
                    .foregroundColor(accentColor)
            }
        )
        .sheet(isPresented: $showingTimerSheet) {
            TimerSheetView(timeRemaining: $timeRemaining, isTimerRunning: $isTimerRunning)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            // Registra l'ora di inizio
            startTime = Date()
            
            // Configura il timer iniziale con il tempo di riposo del workout
            timeRemaining = workout.restTime
            
            // Configura il timer
            setupTimer()
        }
        .onDisappear {
            // Ferma il timer quando la vista scompare
            timer?.invalidate()
            timer = nil
        }
        .onChange(of: isTimerRunning) { newValue in
            if newValue {
                startTimer()
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    // AGGIORNATO: Funzione per salvare l'allenamento nella cronologia con i dati reali per serie
    private func saveWorkoutToHistory() {
        print("Saving workout in workout history...")
        
        // Calcola la durata effettiva dell'allenamento
        let endTime = Date()
        let durationInSeconds = startTime != nil ? endTime.timeIntervalSince(startTime!) : 0
        let durationInMinutes = max(Int(durationInSeconds / 60), 1) // Almeno 1 minuto
        
        print("Calculated duration: \(durationInMinutes) minutes")
        
        // NUOVO: Crea una copia del workout con i dati reali per ogni serie
        var updatedWorkout = workout
        for i in 0..<updatedWorkout.exercises.count {
            let exerciseId = updatedWorkout.exercises[i].id.uuidString
            
            // Salva le ripetizioni effettive per ogni serie
            if let completedRepsForExercise = completedSets[exerciseId] {
                updatedWorkout.exercises[i].actualReps = completedRepsForExercise
                print("Saved reps for \(updatedWorkout.exercises[i].name): \(completedRepsForExercise)")
            }
            
            // Salva i pesi effettivi per ogni serie
            if let weightsForExercise = exerciseWeights[exerciseId] {
                updatedWorkout.exercises[i].actualWeights = weightsForExercise
                // Calcola peso medio per compatibilità con il campo weight
                let validWeights = weightsForExercise.compactMap { $0 }
                if !validWeights.isEmpty {
                    let averageWeight = validWeights.reduce(0, +) / Double(validWeights.count)
                    updatedWorkout.exercises[i].weight = averageWeight
                }
                print("Saved weights for \(updatedWorkout.exercises[i].name): \(weightsForExercise)")
            }
        }
        
        // Usa il workout aggiornato con i dati reali
        workoutManager.completeWorkout(updatedWorkout)
        
        if let encodedData = try? JSONEncoder().encode(workoutManager.workoutHistory) {
            UserDefaults.standard.set(encodedData, forKey: "workoutHistory")
            print("Completed saving in UserDefaults")
        }
        
        print("Added workout to history with real data per set. Record count: \(workoutManager.workoutHistory.count)")
    }
    
    private func setupTimer() {
        // Configura il timer
        timer = nil
    }
    
    private func toggleTimer() {
        isTimerRunning.toggle()
    }
    
    // AGGIORNATO: Funzione timer migliorata con auto-reset e chiusura sheet
    private func startTimer() {
        if timeRemaining > 0 {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                } else {
                    // Timer completato - implementa le nuove funzionalità
                    handleTimerCompletion()
                }
            }
        } else {
            isTimerRunning = false
        }
    }
    
    // NUOVO: Gestisce il completamento del timer
    private func handleTimerCompletion() {
        // Ferma il timer
        isTimerRunning = false
        timer?.invalidate()
        timer = nil
        
        // Chiudi la sheet del timer se è aperta
        withAnimation(.easeInOut(duration: 0.3)) {
            showingTimerSheet = false
        }
        
        // Resetta il tempo al valore di riposo del workout
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            timeRemaining = workout.restTime
        }
        
        // Suono + Vibrazione quando il timer finisce
        playTimerComplete()
        
        // Opzionale: Mostra un breve messaggio di completamento
        // Potresti aggiungere un toast o un'animazione qui
    }
    
    // Funzione per riprodurre suono di completamento timer
    private func playTimerComplete() {
        // Vibrazione forte per 3 secondi
        startLongVibration()
        
        // Suono forte di allarme (si sente anche in modalità silenziosa)
        playLoudAlarmSound()
    }
    
    // Vibrazione forte che dura 3 secondi
    private func startLongVibration() {
        let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
        
        // Vibrazione immediata
        heavyImpact.impactOccurred()
        
        // Continua a vibrare ogni 0.3 secondi per 3 secondi totali
        var vibrationCount = 0
        let totalVibrations = 10 // 3 secondi / 0.3 = 10 vibrazioni
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            vibrationCount += 1
            heavyImpact.impactOccurred()
            
            if vibrationCount >= totalVibrations {
                timer.invalidate()
            }
        }
    }
    
    // Suono forte che si sente anche in modalità silenziosa
    private func playLoudAlarmSound() {
        // Configura l'audio per riprodurre anche in modalità silenziosa
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio configuration error: \(error)")
        }
        
        // Suono di allarme forte (sistema iOS)
        AudioServicesPlaySystemSound(1005) // Voicemail sound - più forte
        
        // Alternativa: suono di campanello
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AudioServicesPlaySystemSound(1013) // Bell sound
        }
        
        // Se ancora non si sente, usa la vibrazione di sistema classica
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
}
