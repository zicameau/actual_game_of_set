//
//  Set.swift
//  Game_Of_Set
//
//  Created by admin on 9/10/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation

class Set {
    var deck: Deck
    var hand: Array<Card>
    var score: Int
    var selectedCards: Array<Int>
    var numCardsSelected: Int { // represents the number of cards that are currently selected
        get {
            var count = 0
            for cardIndex in selectedCards {
                if cardIndex != -1 {
                    count += 1
                }
            }
            return count
        }
    }
    
    // Initializes the game of set to have a full deck of 81 shuffled cards
    // an empty hand of an array of cards
    // a selectedCards variable to know which cards are selected in the deck
    // and a numCardsSelected to know how many cards are currently selected.
    init()
    {
        deck = Deck()
        hand = []
        selectedCards =  [-1, -1, -1] // -1 represents 0 in this case because 0 is an element in the array
        score = 0
        
        for _ in 0...11 {
            if let topCard = deck.pullCard() {
                hand.append(topCard)
            }
        }
    }
     // Returns the current array of cards in the hand to the caller
    func getHand() -> [Card] {
        return hand
    }
    
     // Deals three cards to the current hand and returns true if it succeeded and false if not.
    func dealThree() -> Bool{
        for _ in 0...2 {
            if let topCard = deck.pullCard() {
                hand.append(topCard)
            }
            else{
                return false
            }
        }
        return true
    }
    
    func getNumCardsInHand() -> Int {
        return hand.count
    }
    
    // checks to make sure the passed value is a valid index into the hand array
    func checkValidHandIndex(indexIntoHand: Int) -> Bool {
        if indexIntoHand < hand.count {
            return true
        }
        else {
            return false
        }
    }
    
    // Returns false if the index has already been selected
    // returns true if not
    func checkCardNotAlreadySelected(indexIntoHand: Int) -> Bool {
        for i in 0...self.selectedCards.count-1{
            if self.selectedCards[i] == indexIntoHand {
                return false
            }
        }
        return true
    }
    
    // if its a valid index into hand and the max number of cards has not been reached and the card is not already selected
    // then return true. Otherwise return false.
    func selectCard(indexIntoHand: Int) -> Bool {
        if checkValidHandIndex(indexIntoHand: indexIntoHand) &&
            checkCardNotAlreadySelected(indexIntoHand: indexIntoHand) {
            if self.numCardsSelected < 3 {
                for i in 0...self.selectedCards.count-1{
                    if self.selectedCards[i] == -1 {
                        self.selectedCards[i] = indexIntoHand
                        return true
                    }
                }
                return false
            }
            else {
                self.selectedCards[2] = indexIntoHand
                return true
            }
        }
        return false
    }
    
    // If a card of that index has been selected then remove it and return true.
    // Otherwise return false if that card has not been selected.
    func deselectCard(indexIntoHand: Int) -> Bool {
        for i in 0...selectedCards.count-1{
            if self.selectedCards[i] == indexIntoHand {
                self.selectedCards[i] = -1
                score -= 1
                return true
            }
        }
        return false
    }
    // Removes the selected cards from the hand when told to do so. Checks if the selected cards are a set before
    // removing them. Once check returns true it removes them and appends them to the matchedCards array.
    // If the cards are a set and we remove them, deal three more cards (according to the document)
    
    func removeSetFromHand() -> Bool {
        if checkIfSelectedCardsAreSet() {
            print(hand)
            print(selectedCards) 
            for i in 0...2{
                print(hand[i])
                hand.remove(at: selectedCards[i] - 1)
            }
            score += 3
            return true
        }
        else {
            score -= 4
            return false
        }
    }
    
    // Checks if the currently three selected cards are a set or not. If they are then we
    // add them to the array of matchedCards and return true and if they are not then we return false
    func checkIfSelectedCardsAreSet() -> Bool {
        
        var checkFlag = true
        
        if numCardsSelected == 3 {
            
            if !Card.checkColorsSet(firstCard: hand[selectedCards[0]], secondCard: hand[selectedCards[1]], thirdCard: hand[selectedCards[2]]) {
                checkFlag = false
            }
            
            if !Card.checkShadesSet(firstCard: hand[selectedCards[0]], secondCard: hand[selectedCards[1]], thirdCard: hand[selectedCards[2]]) {
                checkFlag = false
            }
            
            if !Card.checkShapesSet(firstCard: hand[selectedCards[0]], secondCard: hand[selectedCards[1]], thirdCard: hand[selectedCards[2]]) {
                checkFlag = false
            }
            
            if !Card.checknumShapesSet(firstCard: hand[selectedCards[0]], secondCard: hand[selectedCards[1]], thirdCard: hand[selectedCards[2]]) {
                checkFlag = false
            }
            
        }
        else {
            checkFlag = false
        }
        
        return checkFlag
    }
    
}
