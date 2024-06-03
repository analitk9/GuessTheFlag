//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Denis Evdokimov on 5/21/24.
//

import SwiftUI

struct ContentView: View {
   @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
   @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var gameOver = false
    @State private var moveInGame = 8
    
    @State private static var tappedView = Int.max
    private var opacityCondition: ((Int)-> Double) = { num in
         tappedView < Int.max ? num == tappedView ? 1 : 0.25 : 1
    }
    private var rotationCondition: ((Int,Int)-> Double) = { num, correctAnswer in
        tappedView < Int.max ? num == correctAnswer ? 360 : 0 : 0
    }
    
    var body: some View {
        
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
       
            VStack {
                Spacer()
                Text("Отгадай флаг")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    Text("Нажми на флаг")
                        .foregroundStyle(.secondary)
                        .font(.subheadline.weight(.heavy))
                    Text(countries[correctAnswer])
                        
                        .font(.largeTitle.weight(.semibold))
                    ForEach(0..<3) { num in
                        Button(action: { flagTapped(num) }, label: {
                            let flagName = countries[num]
                            FlagView(flagName: flagName)
                                .opacity(opacityCondition(num))
                                .rotation3DEffect(.degrees(rotationCondition(num, correctAnswer)),
                                                    axis: (x: 0.0, y: 1.0, z: 0.0))
                               
                        })

                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
            Spacer()
            Spacer()
                Text("Ваши очки \(score)")
                    .blueLargeText()
            }
            .padding()
            Spacer()
            Spacer()
                
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Продолжить") { askQuestion() }
        }message: {
            Text("Ваши очки \(score)")
        }
        .alert("Конец Игры", isPresented: $gameOver) {
            Button("Перезапуск игры") { reset() }
        } message: {
            Text("Ваши итоговые очки \(score)")
        }
       
    }
    
   private func flagTapped(_ number: Int){
       ContentView.tappedView = number
        if number == correctAnswer {
            scoreTitle = "Правильно"
            score += 1
        } else {
            scoreTitle = "Не правильно"
            score -= 1
        }
       moveInGame -= 1
       if moveInGame == 0 {
           gameOver = true
       } else {
           showingScore = true
       }
       
    }
    private func askQuestion(){
        countries.shuffle()
       correctAnswer = Int.random(in: 0...2)
        ContentView.tappedView = Int.max
    }
    private func reset() {
        score = 0
        gameOver = false
        moveInGame = 8
        ContentView.tappedView = Int.max
    }
}


struct BlueText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }

}

extension View {
    func blueLargeText()-> some View {
        modifier(BlueText())
    }
}


#Preview {
    ContentView()
}
