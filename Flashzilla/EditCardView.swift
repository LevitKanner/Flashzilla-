//
//  EditCardView.swift
//  Flashzilla
//
//  Created by Levit Kanner on 22/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct EditCardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var cards = [Card]()
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("New Card")){
                    TextField("prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button(action: {
                        self.addCard()
                    }){
                        Text("Add Card")
                    }
                }
                
                
                Section{
                    ForEach(0..<self.cards.count , id: \.self){ index in
                        VStack(alignment: .leading){
                            Text("\(self.cards[index].prompt)")
                                .font(.custom("AvenirNext", size: 20))
                            
                            Text("\(self.cards[index].answer)")
                                .font(.custom("Optima", size: 15))
                        }
                    }
                    .onDelete { (indexSet) in
                        self.deleteCard(at: indexSet)
                    }
                }
            }
            .navigationBarTitle("Edit Cards")
            .navigationBarItems(leading: EditButton() , trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }){
                Text("Done")
            })
                .listStyle(GroupedListStyle())
                .onAppear(){
                    ///Perform Loading Data
                    self.loadData()
            }
            
            
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func deleteCard(at offsets: IndexSet){
        self.cards.remove(atOffsets: offsets)
        self.saveData()
    }
    
    
    
    func saveData(){
        if let cards = try? JSONEncoder().encode(self.cards){
            UserDefaults.standard.set(cards, forKey: "Cards")
        }
    }
    
    
    func loadData(){
        if let loadedData = UserDefaults.standard.data(forKey: "Cards"){
            if let decodedData = try? JSONDecoder().decode([Card].self, from: loadedData){
            self.cards = decodedData
            }
        }
    }
    
    
    func addCard(){
        guard !self.newAnswer.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !self.newPrompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {return}
        let newCard = Card(prompt: self.newPrompt, answer: self.newAnswer)
        self.cards.insert(newCard, at: 0)
        self.saveData()
    }
}

struct EditCardView_Previews: PreviewProvider {
    static var previews: some View {
        EditCardView()
    }
}
