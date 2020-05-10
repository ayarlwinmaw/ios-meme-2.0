//
//  SentMemesDetailViewController.swift
//  MemeMe
//
//  Created by Ayar Lwin Maw on 5/6/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import Foundation
import UIKit

class SentMemesDetailViewController: UIViewController{
    
    // MARK: Properties
    var meme: Meme!
    
    // MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycles
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // set imageview
        self.imageView!.image = meme.memedImage
        
        // Hide Tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let avController = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
        avController.modalPresentationStyle = .popover
        
        present(avController, animated: true, completion: nil)
    }
    
    @IBAction func editMeme(_ sender: Any) {
        // create an instance of editing meme controller
        let editMemeController = self.storyboard!.instantiateViewController(identifier: "MemeViewController") as! ViewController
        
        // assign editing meme object in editing controller
        editMemeController.editingMeme = self.meme
        
        // present editing controller
        self.present(editMemeController, animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unhide tab bar
        self.tabBarController?.tabBar.isHidden = false
    }
}
