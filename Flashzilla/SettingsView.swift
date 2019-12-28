//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Levit Kanner on 28/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var addWrongCards: Bool
    
    
    var body: some View {
        NavigationView{
            Form{
                Toggle(isOn: $addWrongCards) {
                    Text("Replay Cards")
                }
            }
            .onAppear{
                self.loadState()
            }
        .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done"){
                self.saveSetting()
                self.presentationMode.wrappedValue.dismiss()
                
            })
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    //Saves game settings to userDefaults
    func saveSetting(){
        if let gameState = try? JSONEncoder().encode(self.addWrongCards){
             UserDefaults.standard.set(gameState, forKey: "GameState")
        }
    }
    
    func loadState(){
        if let gameState = UserDefaults.standard.data(forKey: "GameState"){
            let decodedState = try? JSONDecoder().decode(Bool.self, from: gameState)
            self.addWrongCards = decodedState ?? false
        }
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var addWrongCards = false
//    static var previews: some View {
//        SettingsView(addWrongCards: addWrongCards)
//    }
//}
