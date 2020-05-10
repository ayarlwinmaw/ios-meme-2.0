//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Ayar Lwin Maw on 5/5/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    
    // Dummy Memes for testing
    private lazy var myFunction: Void = {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(Meme(topText: "Лорем ипсум долор сит амет хас.", bottomText: "Лорем ипсум долор сит амет вис.", originalImage: #imageLiteral(resourceName: "leonardo"), memedImage: #imageLiteral(resourceName: "leonardo")))
        appDelegate.memes.append(Meme(topText: "Лорем ипсум долор сит амет ид.", bottomText: "Лорем ипсум долор сит амет афферт.", originalImage: #imageLiteral(resourceName: "april-fool"), memedImage: #imageLiteral(resourceName: "april-fool")))
        appDelegate.memes.append(Meme(topText: "Лорем ипсум долор сит амет мел.", bottomText: "Лорем ипсум долор сит амет ерос.", originalImage: #imageLiteral(resourceName: "you-mean"), memedImage: #imageLiteral(resourceName: "you-mean")))
    }()
    
    // MARK: Meme Array from Appdelegate
    var memes: [Meme]!{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // MARK: Properties
    var allMemes: [Meme]! = nil
    var memesCount: Int = 0
    
    // MARK: Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // declare table dataSource and delegate
        tableView.dataSource = self
        tableView.delegate = self
        

       // unit test
        _ = myFunction
        
        // reorder meme arrays and get totoal count
        self.allMemes = memes.reversed()
        self.memesCount = allMemes.count
        
        
        
        // to reload tableView
        tableView.reloadData()
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

    }

    // MARK: TableView numberofRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    // MARK: TableView cellForRowAt
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get reuseable cell with identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableCell") as! SentMemesTableCell
        
        // get a meme from arrays
        let meme = self.allMemes[(indexPath as NSIndexPath).row]

        // set data in each cell row
        cell.memedImageView?.image = meme.memedImage
        cell.topTextLabel?.text = meme.topText
        cell.bottomTextLabel?.text = meme.bottomText
        
  
        cell.memedImageView?.layer.cornerRadius = 10
  
        
        return cell
    }
    
    // MARK: Tableview Didselect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // set a destination and assign a meme value when a row is selected
        let detailController = self.storyboard!.instantiateViewController(identifier: "SentMemesDetailController") as! SentMemesDetailViewController
        detailController.meme = self.allMemes[(indexPath as NSIndexPath).row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    // MARK: Tabview canEdit
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: TableView commit Editing
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            let orignalIndex = (memes.count - indexPath.row) - 1
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.memes.remove(at: orignalIndex)
            allMemes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
    }
    // MARK: Add New Meme
    @IBAction func addNewMeme(_ sender: Any) {
        
        let memeViewController = self.storyboard!.instantiateViewController(identifier: "MemeViewController") as! ViewController
        self.present(memeViewController, animated: true, completion: nil)
 
    }
}
