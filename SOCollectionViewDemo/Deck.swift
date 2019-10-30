//
//  Deck.swift
//  Game_Of_Set
//
//  Created by admin on 9/13/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

struct Deck {
    var cards: Array<Card>
    
    init() {
        cards = []
        for shade in Shades.allCases {
            for shape in Shapes.allCases {
                for i in 1...3 {
                    cards.append(Card(numShapes: i, shp: shape, shade: shade, col: UIColor.Colors.Red))
                    cards.append(Card(numShapes: i, shp: shape, shade: shade, col: UIColor.Colors.Blue))
                    cards.append(Card(numShapes: i, shp: shape, shade: shade, col: UIColor.Colors.Green))
                }
            }
        }
        self.shuffleDeck()
    }
    
    mutating func shuffleDeck() {
        cards.shuffle()
    }
    
    mutating func pullCard() -> Card?{
        return cards.popLast() ?? nil
    }
}
