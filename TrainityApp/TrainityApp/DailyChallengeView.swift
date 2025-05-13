//
//  DailyChallengeView.swift
//  TrainityApp
//
//  Created by riccardo raffa on 13/05/25.
//


import SwiftUI

struct DailyChallengeView: View {
    // Array per tracciare i giorni completati della settimana
    @State private var daysCompleted = [false, false, false, false, false, false, false]
    @State private var totalCompleted = 0 // Giorni completati

    // Giorni della settimana abbreviati
    let daysOfWeek = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

    var body: some View {
        VStack {
            Text("Daily Challenge")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()

            // Barra di avanzamento per i giorni completati
            ProgressBar(completed: totalCompleted)

            // Visualizzazione dei giorni della settimana
            HStack {
                ForEach(0..<7, id: \.self) { index in
                    VStack {
                        // Cerchio colorato per ogni giorno
                        Circle()
                            .fill(self.daysCompleted[index] ? Color.green : Color.gray)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text(self.daysOfWeek[index]) // Mostra abbreviazione solo per il giorno corrente
                                    .foregroundColor(self.isToday(index) ? .white : .clear) // Evidenzia solo oggi
                                    .font(.caption)
                                    .bold()
                            )
                    }
                    .padding(5)
                }
            }



            Spacer()

            // Pulsante per segnare il completamento di un giorno
            Button(action: {
                // Calcola l'indice del giorno corrente
                let currentDay = getCurrentDayIndex()

                // Se il giorno non è già stato completato
                if !daysCompleted[currentDay] {
                    daysCompleted[currentDay] = true
                    totalCompleted += 1
                }
            }) {
                Text("Complete Today")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()
        }
        .padding()
    }

    // Funzione per ottenere l'abbreviazione del giorno (MON, TUE, ecc.)
    func getDayAbbreviation(_ index: Int) -> String {
        return daysOfWeek[index]
    }

    // Funzione per verificare se il giorno è oggi
    func isToday(_ index: Int) -> Bool {
        return index == getCurrentDayIndex()
    }

    // Funzione che restituisce l'indice del giorno corrente (0 = Domenica, 6 = Sabato)
    func getCurrentDayIndex() -> Int {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: Date())
        return dayOfWeek - 1 // Mappa la Domenica a 0, Lunedì a 1, ecc.
    }
}

// Componente per la barra di avanzamento
struct ProgressBar: View {
    var completed: Int

    var body: some View {
        VStack {
            HStack {
                Text("Progress")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.leading)
                Spacer()
            }
            
            // Barra di avanzamento
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 10)
                    .foregroundColor(.gray)
                Capsule()
                    .frame(width: CGFloat(completed) / 7 * UIScreen.main.bounds.width, height: 10)
                    .foregroundColor(.green)
            }
            .padding()
        }
    }
}
