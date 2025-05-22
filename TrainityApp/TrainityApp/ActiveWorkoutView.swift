import SwiftUI
import AudioToolbox

struct ActiveWorkoutView: View {
    let workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var workoutManager: WorkoutManager
    @State private var completedSets: [String: [Int]] = [:]
    @State private var currentExerciseIndex = 0
    @State private var showingCompletionAlert = false
    @State private var showingTimerSheet = false
    @State private var timeRemaining: Int = 60
    @State private var isTimerRunning: Bool = false
    @State private var timer: Timer? = nil
    @State private var startTime: Date? = nil
    
    var body: some View {
        ZStack {
            Color(red: 0.9, green: 0.95, blue: 0.95).edgesIgnoringSafeArea(.all)
            
            VStack {
                // Header
                Text("Allenamento: \(workout.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    .padding(.top, 20)
                
                // Progress indicator
                ProgressView(value: Double(currentExerciseIndex), total: Double(workout.exercises.count))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .tint(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                Text("\(currentExerciseIndex)/\(workout.exercises.count) esercizi completati")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
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
                        .background(Color(red: 0.1, green: 0.4, blue: 0.4).opacity(0.3))
                    
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
                                        .fill(Color(red: 0.1, green: 0.4, blue: 0.4))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: isTimerRunning ? "pause.fill" : "play.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.trailing, 10)
                            
                            // Timer display
                            VStack(alignment: .leading) {
                                Text("Timer Recupero")
                                    .font(.subheadline)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                
                                Text("\(timeRemaining) secondi")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                            }
                            
                            Spacer()
                            
                            // Drag indicator
                            Image(systemName: "chevron.up")
                                .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                                .padding(.trailing)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(Color(red: 0.9, green: 0.95, blue: 0.95))
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
                Text("Termina")
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
            }
        )
        .sheet(isPresented: $showingTimerSheet) {
            TimerSheetView(timeRemaining: $timeRemaining, isTimerRunning: $isTimerRunning)
                .presentationDragIndicator(.visible)
        }
        .alert(isPresented: $showingCompletionAlert) {
            Alert(
                title: Text("Allenamento Completato"),
                message: Text("Hai completato tutti gli esercizi dell'allenamento!"),
                primaryButton: .default(Text("Salva Risultati")) {
                    // Salva l'allenamento nella cronologia
                    saveWorkoutToHistory()
                    
                    timer?.invalidate()
                    timer = nil
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel(Text("Chiudi")) {
                    timer?.invalidate()
                    timer = nil
                    presentationMode.wrappedValue.dismiss()
                }
            )
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
    
    // Funzione per salvare l'allenamento nella cronologia
    private func saveWorkoutToHistory() {
        print("Salvaggio allenamento nella cronologia...")
        
        // Calcola la durata effettiva dell'allenamento
        let endTime = Date()
        let durationInSeconds = startTime != nil ? endTime.timeIntervalSince(startTime!) : 0
        let durationInMinutes = max(Int(durationInSeconds / 60), 1) // Almeno 1 minuto
        
        print("Durata calcolata: \(durationInMinutes) minuti")
        
        // Usa direttamente il metodo completeWorkout che già esiste nel workoutManager
        // questo dovrebbe fare tutto ciò che serve (aggiungere il record e aggiornare le statistiche)
        workoutManager.completeWorkout(workout)
        
        print("Allenamento aggiunto alla cronologia. Totale record: \(workoutManager.workoutHistory.count)")
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
        // Vibrazione di successo
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(.success)
        
        // Suono di completamento (suono di invio messaggio iOS)
        AudioServicesPlaySystemSound(1001)
    }
}
