//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Ayar Lwin Maw on 5/1/20.
//  Copyright © 2020 Ayar Maw. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIFontPickerViewControllerDelegate {

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

    // MARK: Meme Struct
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage!
        var memedImage: UIImage!
    }
    
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
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Pick An Image from Album
    @IBAction func pickAnImage(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Take A Picture from Camera
    @IBAction func takeAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .camera
       pickerController.allowsEditing = true
       // pickerController.cameraOverlayView = imagePickerView
        present(pickerController, animated: true, completion: nil)
    }
    
    // MARK: Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.editedImage] as? UIImage{
           // imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
            self.shareButton.isEnabled = true
        }else if let image = info[.originalImage] as? UIImage{
            imagePickerView.image = image
            self.shareButton.isEnabled = true
        
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
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
        
        let meme = Meme(topText: topTextField.text! , bottomText: bottomTextField.text! , originalImage: imagePickerView.image!, memedImage: memedImage!)
        print(meme)
        
    }
    
    // MARK: Share Meme Image
    @IBAction func shareMeme(_ sender: Any) {
       memedImage = generateMemedImage()
              let avController = UIActivityViewController(activityItems: [memedImage!], applicationActivities: nil)
              self.present(avController, animated: true, completion: nil)
              
              //Completion handler
              avController.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnItems: [Any]?, error: Error?) in
                  if completed {
                      self.saveMeme()
                      return
                  }else{
                      
                  }
                  if let shareError = error {
                      print(shareError)
                  }
              }
        
    }
    
    // MARK: Generate Meme Image
    func generateMemedImage() -> UIImage {
        
        //hide ToolBar and NavBar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //unhide ToolBar and NavBar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    @IBAction func clearCurrentMeme(_ sender: Any) {
        topTextField.text = "TOP TEXT HERE"
        bottomTextField.text = "BOTTOM TEXT HERE"
        imagePickerView.image = nil
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        
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

