//
//  ContentView.swift
//  Flashzilla
//
//  Created by Levit Kanner on 18/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @State private var cards = [Card](repeating: Card.example, count: 10)
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @State var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var AppActive = true
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack{
                Text("Time remaining: \(self.timeRemaining)")
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(.horizontal , 20)
                    .padding(.vertical)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Capsule())
                    Spacer()
                }
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView_(card: self.cards[index], removal:{
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        })
                            .stacked(at: index, in: self.cards.count)
                    }
                }
                .padding(.top , 25)
            }
            ///Appears when the differentiateWithoutColor accessibility is enabled in settings
            if differentiateWithoutColor {
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName: "xmark.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(self.timer) { (time) in
            ///Counts down only when the application is active 
            guard self.AppActive else {return}
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            }
        }
            ///Detects when the application is entering the background
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { (_) in
            ///Update the active state of the application
            self.AppActive = false
        }
            
            ///Detects when the applicaton is being opened again
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { (_) in
            self.AppActive = true
        }
    }
    
    func removeCard(at index: Int){
        self.cards.remove(at: index)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


extension View {
    func stacked(at index: Int , in total: Int ) -> some View {
        let offset = index - total
        return self.offset(CGSize(width: 0, height: offset * 10 ))
    }
}


