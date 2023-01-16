//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Manuel Moyano on 02/11/2021.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.blue)
            .font(.largeTitle)
}
}
extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}


struct FlagImage: View {
    var country: String
    var body: some View {
                Image(country)
                    .renderingMode (.original)
                    .clipShape(Capsule())
                    .shadow(radius: 10)
        
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var countries = ["estonia", "france", "germany", "ireland", "italy", "nigeria", "poland", "russia", "spain", "uk", "us"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var scoreText = ""
    @State private var contador = 0
    @State private var endGame = false
    @State private var numbertapped = 0
    @State private var animationAmount = 0.0
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    
    
    var body: some View {
        ZStack {
            LinearGradient( gradient: Gradient(colors: [.white,Color(red:0.1,green:0.2,blue:0.45)]),startPoint: .top,endPoint: .bottom)
                .ignoresSafeArea()
            
                VStack (spacing:30) {
                    
                    VStack {
                        Text ("Tap the flag of")
//                          .foregroundColor(.black)
                            .modifier(Title())
                        Text (countries[correctAnswer])
                            .foregroundColor(.black)
                            .font(.largeTitle.weight(.semibold))
                    }
                        ForEach (0..<3) {number in
                            Button {
                                withAnimation {
                                    flagTapped(number)
                                }
                            }
                            label: {
                                if numbertapped == number {
                                FlagImage(country: countries[number])
                                .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: 1, z: 0))
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                                } else {
                                    FlagImage(country: countries[number])
                                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                                }
                                
                                
                            }
                        }
                    
                    Text ("Your Score is: \(scoreText)")
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.semibold))
                  }
            } .alert(scoreTitle, isPresented: $showingScore){
                    Button ("Continue", action: askQuestion)
                }
              .alert("Game Over", isPresented: $endGame){
                    Button ("Play Again", action: askQuestion)
                }
        }
    func flagTapped(_ number: Int) {
        numbertapped = number
        animationAmount += 360
        if number == correctAnswer {
            scoreTitle = "Correct"
            score = score + 1
            scoreText = String(score)
        } else {
            scoreTitle = "Wrong, this is the Flag of \(countries[number])"
        }
        showingScore = true
        }
    func askQuestion() {
        contador = contador + 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        animationAmount = 0
        if contador == 8 {
                endGame = true
                contador = 0
                score = 0
                scoreText = String(score)
        }
        }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
