//
//  CardView .swift
//  Flashzilla
//
//  Created by Levit Kanner on 20/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct CardView_: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    let card: Card
    @State var showingAnswer = false
    @State var offset: CGSize = .zero
    var removal: (() -> Void)? = nil
    
    
    var body: some View {
        ///Creates a drag gesture
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
                    ///Fades the white color of the card when it is being dragged
                    .fill(
                        differentiateWithoutColor ?
                            Color.white :
                            Color.white
                                .opacity(1 - Double(abs(offset.width * 1 / 50 ))
                        )
                )
                    /// Colors card red when offset width is lesser than zero ie. When the card is moved to the left
                    .background(
                        differentiateWithoutColor ?
                            nil :
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(offset.width > 0 ? Color.green : Color.red)
                )
                    .shadow(radius: 10)
                
                
                VStack{
                    Text(card.prompt)
                        .font(.custom("AvenirNext-DemiBold", size: 30))
                    
                    ///Shows the answer when the card is tapped
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
            .rotationEffect(Angle(degrees: Double(self.offset.width / 5)))
            .offset(x: offset.width * 5 , y: 0 )
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
