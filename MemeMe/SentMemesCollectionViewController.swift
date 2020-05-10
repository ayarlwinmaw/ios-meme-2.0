//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Ayar Lwin Maw on 5/6/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    let reuseIdentifier = "SentMemesCollectionViewCell"
    var allMemes: [Meme]! = nil
    var memesCount: Int = 0
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reorder meme arrays and get totoal count
        self.allMemes = memes.reversed()
        self.memesCount = allMemes.count
        collectionView!.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // MARK: Flow Layout dimensions
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space) - 20) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        
        // configure meme
        let meme = self.allMemes[(indexPath as NSIndexPath).row]
        cell.imageView!.image = meme.memedImage
        // cell designs
        cell.contentView.layer.cornerRadius = 7.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemesDetailController") as! SentMemesDetailViewController
        detailController.meme = self.allMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Add New Meme
    @IBAction func addNewMeme(_ sender: Any) {
       let memeViewController = self.storyboard!.instantiateViewController(identifier: "MemeViewController") as! ViewController
        present(memeViewController, animated: true, completion: nil)
    }
}
