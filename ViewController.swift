//
//  ViewController.swift
//  SOCollectionViewDemo
//
//  Created by admin on 10/26/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionCell"

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var game = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.allowsMultipleSelection = true
        // Do any additional setup after loading the view.
    }

    // UICollectionViewDelegateFlowLayout functions
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 75.0, height: 105.0)
    }
    
    func collectionView(_: UICollectionView, layout: UICollectionViewLayout, minimumLineSpacingForSectionAt: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return game.hand.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        // Current hand
        var hand = game.getHand()
        let card = hand[indexPath.item]
        
        
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 75, height: 105)
        var fancyText = NSMutableAttributedString(string: String(repeating: card.shape.rawValue, count: card.numberOfShapes) )
        
        
        
        
        if card.shading.rawValue == 0.0{
            fancyText.addAttribute(NSAttributedString.Key.strokeWidth, value: 3.0, range:NSRange(location: 0, length: fancyText.length))
            label.attributedText = fancyText
            label.textColor = card.color
        }
        else {
            fancyText.addAttribute(NSAttributedString.Key.strokeWidth, value: 0.0, range:NSRange(location: 0, length: fancyText.length))
            label.attributedText = fancyText
            var rgba = card.color.rgba
            label.textColor = UIColor(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: CGFloat(card.shading.rawValue))
        }
        
        
        label.textAlignment = NSTextAlignment.center
        cell.backgroundColor = UIColor.white
        
        if cell.isSelected {
            cell.layer.borderColor = UIColor.blue.cgColor
            cell.layer.borderWidth = 3
        }
        else {
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 1
        }
        
        cell.addSubview(label)
        
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !game.checkIfSelectedCardsAreSet() {
            if game.numCardsSelected < 3 {
                game.selectCard(indexIntoHand: indexPath.item)
                let cell = collectionView.cellForItem(at: indexPath)
                cell!.layer.borderColor = UIColor.blue.cgColor
                cell!.layer.borderWidth = 3
            }
            else {
                let indexPathPrev = IndexPath(row: game.selectedCards[2], section: 0)
                let cellPrev = collectionView.cellForItem(at: indexPathPrev)
                
                // Deselect the last element in the game of selected cards
                cellPrev!.layer.borderColor = UIColor.black.cgColor
                cellPrev!.layer.borderWidth = 1
                collectionView.deselectItem(at: indexPathPrev, animated: false)
                
                
                game.deselectCard(indexIntoHand: game.selectedCards[2])
                
                let cell = collectionView.cellForItem(at: indexPath)
                // select the new cell
                cell!.layer.borderColor = UIColor.blue.cgColor
                cell!.layer.borderWidth = 3
                
                game.selectCard(indexIntoHand: indexPath.item)
            }
            
            
            if game.numCardsSelected == 3 {
                if game.checkIfSelectedCardsAreSet()
                {
                    for i in game.selectedCards {
                        let indexPathSelected = IndexPath(row: i, section: 0)
                        let cellSelected = collectionView.cellForItem(at: indexPathSelected)
                        cellSelected!.layer.borderColor = UIColor.green.cgColor
                    }
                }
            }
        }
        else {
            collectionView.deselectItem(at: indexPath, animated: false)
            
            game.removeSetFromHand()
            
            let selectedCells = collectionView.indexPathsForSelectedItems
            collectionView.deleteItems(at: selectedCells!)
            
            game.dealThree()
            
            var paths = [IndexPath]()
            for i in 0...2 {
                print(game.hand.count-4 + i)
                paths.append(IndexPath(row: game.hand.count-1 + i, section: 0))
            }
            collectionView.insertItems(at: paths)
            
            collectionView.reloadData()
        }
        print(game.selectedCards)
    }

    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        game.deselectCard(indexIntoHand: indexPath.item)
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.layer.borderColor = UIColor.black.cgColor
        cell!.layer.borderWidth = 1
        print(game.selectedCards)
    }
    
   

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}


extension UIColor {
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return (red, green, blue, alpha)
    }
}
