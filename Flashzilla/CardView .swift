//
//  CardView .swift
//  Flashzilla
//
//  Created by Levit Kanner on 20/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct CardView_: View {
    let card: Card
    @State var showingAnswer = false
    @State var offset: CGSize = .zero
    var removal: (() -> Void)? = nil
    
    
    
    
    var body: some View {
        
        let gesture = DragGesture()
            .onChanged { (value) in
                self.offset = value.translation
        }
        .onEnded { (_) in
            if abs(self.offset.width) > 100{
                //Remove card
                self.removal?()
            }else{
                self.offset = .zero
            }
        }
        
        
        return
            ZStack{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.white)
                    .shadow(radius: 10)
                
                VStack{
                    Text(card.prompt)
                        .font(.custom("AvenirNext-DemiBold", size: 30))
                    
                    if showingAnswer{
                        Text(card.answer)
                            .font(.custom("Avenir-MediumOblique", size: 25))
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .multilineTextAlignment(.center)
            }
            .frame(width: 450 , height: 250)
                //.rotationEffect(Angle(degrees: Double(self.offset.width / 5)))
                .rotation3DEffect(Angle(degrees: Double(self.offset.width / 5)) , axis: (x: offset.width * 5 , y: offset.width * 5 , z: offset.width * 5 ))
                .offset(x: offset.width * 5 , y: offset.width * 5 )
                .opacity(2 - Double(abs(offset.width / 50)))
                .gesture(gesture)
                .onTapGesture {
                    withAnimation {
                        self.showingAnswer.toggle()
                    }
                    
        }
    }
    
}

struct CardView__Previews: PreviewProvider {
    static var previews: some View {
        CardView_(card: Card.example)
    }
}
