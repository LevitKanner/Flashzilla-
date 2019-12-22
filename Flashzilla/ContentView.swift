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
    ///Properties
    @State private var cards = [Card]()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    
    @State var timeRemaining = 100
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var AppActive = true
    @State private var showingEditView = false
    
    ///Body 
    var body: some View {
        ZStack {
            Image(decorative: "background")
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
                
                ///Creates a stack of cards
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardView_(card: self.cards[index], removal:{
                            withAnimation {
                                self.removeCard(at: index)
                            }
                        })
                            .stacked(at: index, in: self.cards.count)
                            ///Disables interactivity on cards behind the top card
                            .allowsHitTesting(index == self.cards.count - 1)
                            ///Hides card behind the top card from being read by voice Ove. 
                            .accessibility(hidden: index < self.cards.count - 1)
                    }
                }
                .padding(.top , 25)
                    ///Disables interactivity when the time remaining is 0
                    .allowsHitTesting(self.timeRemaining > 0)
                
                ///Displays a button to reset the game when all cards are finished
                if cards.isEmpty {
                    Button(action: {
                        self.resetCards()
                    }){
                        Text("Start Again")
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .shadow(radius: 3)
                }
            }
            
            ///Adds a plus button that presents an Edit view 
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        self.showingEditView = true
                    }){
                        Image(systemName: "plus.circle")
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            ///Appears when the differentiateWithoutColor accessibility is enabled in settings
            if differentiateWithoutColor {
                VStack{
                    
                    Spacer()
                    
                    ///Places a horizontal stack of buttons on the screen
                    HStack{
                        
                        ///First Button
                        Button(action:{
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }){
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Marks choice as wrong"))
                        
                        ///Spacer
                        Spacer()
                        
                        ///Second button
                        Button(action:{
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }){
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Marks choice as being correct"))
                        
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
                ///Brings the application back to active only if the cards array is not empty
                if !self.cards.isEmpty{
                    self.AppActive = true
                }
        }
        .sheet(isPresented: $showingEditView , onDismiss: self.resetCards) {
            EditCardView()
        }
        .onAppear(){
            self.resetCards()
        }
        
    }
    
    ///Method for the removal of card from the cards array
    func removeCard(at index: Int){
        guard index >= 0 else {return}
        self.cards.remove(at: index)
        if cards.isEmpty {
            self.AppActive = false
        }
    }
    
    ///Method for the reseting of games 
    func resetCards(){
        withAnimation(Animation.spring()) {
            self.timeRemaining = 100
            self.AppActive = true
            loadData()
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
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


