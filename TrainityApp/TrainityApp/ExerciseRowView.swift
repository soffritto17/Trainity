//
//  ExerciseRowView.swift
//  TrainityApp
//
//  Created by Giovanni De Rosa on 15/05/25.
//

import SwiftUI

struct ExerciseRowView: View {
    @Binding var exercise: Exercise
    
    var body: some View {
        VStack {
            Text(exercise.name)
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            HStack {
                Stepper("Serie: \(exercise.sets)", value: $exercise.sets, in: 1...10)
                    .frame(maxWidth: .infinity)
                
                Stepper("Rep: \(exercise.reps)", value: $exercise.reps, in: 1...30)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
