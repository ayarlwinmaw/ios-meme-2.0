//
//  SentMemesTableCell.swift
//  MemeMe
//
//  Created by Ayar Lwin Maw on 5/5/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import Foundation
import UIKit
class SentMemesTableCell: UITableViewCell{
    
    @IBOutlet weak var topTextLabel: UILabel! {
        didSet  {
            topTextLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
            topTextLabel.textColor = UIColor.systemGray
        
        }
    }
    @IBOutlet weak var bottomTextLabel: UILabel! {
        didSet{
            bottomTextLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 20)
        }
    }
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var cardView: UIView! {
        didSet {
            cardView.layer.cornerRadius = 20
            cardView.layer.masksToBounds = true
            cardView.layer.shadowOffset = CGSize(width: 0,height: 0.2)
            cardView.layer.shadowOpacity = 0.23
            cardView.layer.shadowRadius = 20
        }
    }
    
}
