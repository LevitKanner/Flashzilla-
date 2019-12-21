//
//  Card.swift
//  Flashzilla
//
//  Created by Levit Kanner on 20/12/2019.
//  Copyright © 2019 Levit Kanner. All rights reserved.
//

import Foundation

struct Card{
    var prompt: String
    var answer: String
    
    static var example: Card{
        Card(prompt: "Who's going to impact lives?", answer: "Levit Osei-Wusu Kanner")
    }
}
