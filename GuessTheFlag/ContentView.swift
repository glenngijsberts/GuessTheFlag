//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Glenn Gijsberts on 16/08/2020.
//  Copyright © 2020 Glenn Gijsberts. All rights reserved.
//

import SwiftUI

struct AnimationValue {
    var amount: Double
    var opacity: Double
    var lineWidth: CGFloat
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Russia", "Poland", "UK", "US", "Nigeria", "Italy", "Ireland"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var pickedCountry = 0
    
    @State private var animationAmount: [AnimationValue] = [
        .init(amount: 0.0, opacity: 1.0, lineWidth: 0.0),
        .init(amount: 0.0, opacity: 1.0, lineWidth: 0.0),
        .init(amount: 0.0, opacity: 1.0, lineWidth: 0.0)
    ]
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            
            animationAmount[number].amount += 360
            
            for i in 0..<animationAmount.count {
                if i == number {
                    animationAmount[i].opacity = 1.0
                } else {
                    animationAmount[i].opacity = 0.25
                }
            }
            
            
        } else {
            animationAmount[number].lineWidth = 5.0
            scoreTitle = "Wrong!"
            pickedCountry = number
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        for number in 0..<animationAmount.count {
            animationAmount[number].opacity = 1.0
            animationAmount[number].lineWidth = 0.0
        }
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 24) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.largeTitle)
                }
                .padding(.top, 16)
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.red, lineWidth: self.animationAmount[number].lineWidth))
                            .opacity(self.animationAmount[number].opacity)
                            .rotation3DEffect(.degrees(self.animationAmount[number].amount), axis: (x: 0, y: 1, z: 0))
                            .animation(.default)
                    }
                }
                
                Text("Current score: \(score)")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .font(.subheadline)
                
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: scoreTitle == "Correct!" ? Text("Your score is \(score)") : Text("Bummer, that's the flag of \(countries[pickedCountry])"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
                })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
