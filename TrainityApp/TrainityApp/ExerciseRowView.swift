//
//  ExerciseRowView.swift
//  TrainityApp
//
//  Created by Giovanni De Rosa on 15/05/25.
//

import SwiftUI

struct ExerciseRow: View {
    let exercise: Exercise
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(exercise.name)
                    .font(.headline)
                    .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                
                HStack {
                    Text("Serie: \(exercise.sets)")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Text("•")
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                    
                    Text("Ripetizioni: \(exercise.reps)")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.1, green: 0.4, blue: 0.4))
                }
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundColor(.red)
                    .padding(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
}
