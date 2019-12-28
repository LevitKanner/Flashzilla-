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
        .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done"){self.presentationMode.wrappedValue.dismiss()})
        }
    .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var addWrongCards = false
//    static var previews: some View {
//        SettingsView(addWrongCards: addWrongCards)
//    }
//}
