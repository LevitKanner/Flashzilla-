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
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("dfasfd")
                .font(.largeTitle)
                Spacer()
                
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
            }
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


