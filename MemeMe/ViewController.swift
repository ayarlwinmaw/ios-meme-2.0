//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by Ayar Lwin Maw on 5/1/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -4.5
    ]
    
    var targetBottom:Bool = false
    var memedImage:UIImage? = nil
    var editingMeme:Meme? = nil
    // MARK: Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.shareButton.isEnabled = false
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        self.topTextField.defaultTextAttributes = memeTextAttributes
        self.bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
        // Propeties for editing meme
        if let topText = editingMeme?.topText{
            topTextField.text = topText
        }
        if let bottomText = editingMeme?.bottomText{
            bottomTextField.text = bottomText
        }
        if let originalImage = editingMeme?.originalImage{
            imagePickerView.image = originalImage
            shareButton.isEnabled = true
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // To check whethre device has a camera or not
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // To subscribe keyboard notifications
        subscribeToKeyboardNotifications()
        
        // Add target to Bottom textField
        bottomTextField.addTarget(self, action: #selector(triggerBottomTextField(_:)), for: .touchDown)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // To unsubscribe keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Functions
    
    // MARK: Pick An Image from Album
    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.modalPresentationStyle = .fullScreen
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Take A Picture from Camera
    @IBAction func takeAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage{
            imagePickerView.image = image
            self.shareButton.isEnabled = true
        }else if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
            self.shareButton.isEnabled = true
        
        }
    }
    
    // MARK: Image Picker Cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Textfield Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    // To clean default text when editing
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let newText = textField.text!
        let topText = "TOP TEXT HERE"
        let bottomText = "BOTTOM TEXT HERE"
        if (newText.elementsEqual(topText) || newText.elementsEqual(bottomText)){
            textField.text = ""
        }
    }
    
    // To replace default text if there is no text
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (topTextField.text == ""){
            topTextField.text = "TOP TEXT HERE"
        }
        if (bottomTextField.text == ""){
            bottomTextField.text = "BOTTOM TEXT HERE"
        }
        targetBottom = false
    }
    
    // To hide keyboard when return is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: To move up the canvas
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if(targetBottom == true){
              view.frame.origin.y = -getKeyBoardHeight(notification)
        }
    }
    
    @objc func keyBoardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // To get Keyboard height
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // To subsribe keyboard notifications in view
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK:  To detect bottom textfield
    @objc func triggerBottomTextField(_ textField: UITextField) {
        targetBottom = true
    }
    
    // MARK: Save Meme
    func saveMeme(){
        // Create a meme object
        let meme = Meme(topText: topTextField.text! , bottomText: bottomTextField.text! , originalImage: imagePickerView.image!, memedImage: memedImage!)

        // Append it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
   
    // MARK: Share Meme Image
    @IBAction func shareMeme(_ sender: Any) {

        // generate meme imaage
        memedImage = generateMemedImage()
        
        // prepare items to share
        let myText = "sent from Meme 2.0"
        let img: UIImage = memedImage!
        let shareItems:Array = [img, myText] as [Any]
        let avController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        avController.popoverPresentationController?.sourceView = self.view
        
        // get a blank transparent view controller
        let fakeViewController = self.storyboard!.instantiateViewController(identifier: "SavedViewController") as! SavedViewController
        fakeViewController.modalPresentationStyle = .overFullScreen
        
        //Competion Hanlder
        avController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
        Bool, arrayReturnedItems: [Any]?, error: Error?) in
            
        // presenting a blank transparent view to avoid autmatic showing back to previous view in iOS 13 updates
            if let presentingViewController = fakeViewController.presentingViewController {
                // when user cancel share
                presentingViewController.dismiss(animated: false, completion: nil)
               
            } else {
                print("Share")
                // when user share
                fakeViewController.dismiss(animated: false, completion: nil)
                // to save meme
                self.saveMeme()
                // to dimiss the Add New Meme View
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        // To present asynchronously a blank transparent view and activity view
        DispatchQueue.main.async {
            self.present(fakeViewController, animated: false) { [weak fakeViewController] in
                fakeViewController?.present(avController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        //hide ToolBar and NavBar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        //Render view to an image
//        UIGraphicsBeginImageContext(self.view.frame.size)
//        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
//        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContext(self.imagePickerView.frame.size)
        view.drawHierarchy(in: self.imagePickerView.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        
        //unhide ToolBar and NavBar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    // MARK: Cancel Button
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Font Picker
    @IBAction func changeFont(_ sender: Any) {
        let vc = UIFontPickerViewController()
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: Font Pikcer Delegate
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
       
        // attempt to read the selected font descriptor, but exit quietly if that fails
        guard let descriptor = viewController.selectedFontDescriptor else { return }

        let font = UIFont(descriptor: descriptor, size: 40)
        topTextField.font = font
        bottomTextField.font = font
    }
    
}
