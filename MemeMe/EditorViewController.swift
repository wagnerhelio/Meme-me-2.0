//
//  EditorViewController.swift
//  MemeMe
//
//  Created by Wagner  Filho on 05/08/2018.
//  Copyright © 2018 Artesmix. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate {

    @IBOutlet var imagePickerView: UIImageView!
    
    @IBOutlet var btnCancel: UIBarButtonItem!
    @IBOutlet var btnShare: UIBarButtonItem!
    @IBOutlet var btnCamera: UIBarButtonItem!
    @IBOutlet var btnLibrary: UIBarButtonItem!
    
    @IBOutlet var textBotton: UITextField!
    @IBOutlet var textTop: UITextField!
    
    @IBOutlet var toolBar: UIToolbar!
    @IBOutlet var navBar: UINavigationBar!
    
    @IBOutlet var scrollView: UIScrollView!
    
    
    // MARK: - Override Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        setText(textField: textTop, string: "Top")
        setText(textField: textBotton, string: "Bottom")

    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true

        //share button disable or enable
        if let _ = imagePickerView.image {
            btnShare.isEnabled = true
        } else {
            btnShare.isEnabled = false
        }
        
        // Deiable camera
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Keyboard
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    // MARK: - Func
    //Text Padronized
    
    func setText(textField: UITextField, string: String){
        textField.text = string
        textField.defaultTextAttributes = memeMeTextAttributes
        textField.textAlignment = .center
        textField.delegate = self
        textField.borderStyle = .none
    }
    let memeMeTextAttributes:[String:Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black ,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "impact", size: 30)!,
        NSAttributedStringKey.strokeWidth.rawValue: -3.0
    ]
    
    
    
    //Text Clear after click
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "Top" || textField.text == "Bottom"{
            textField.text = ""
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    //Select Photho in Library or Camera
    func selectImage(sourceImage: UIImagePickerControllerSourceType){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = sourceImage
        present(imagePicker, animated: true, completion: nil)
    }

    //Oculte navigation bar for generate image
    func hiddenBars(isHidden: Bool){
        
        navBar.isHidden = isHidden
        toolBar.isHidden = isHidden
        
    }
    
    func generateMemedImage() -> UIImage{
        
        //Navication Print
        hiddenBars(isHidden: true)
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Naviation Bar Hidden
        hiddenBars(isHidden: false)
        
        return memedImage
    }
    
    //Resume Keyboard
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditorViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        // Keyboard to show
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        
        //Keyboard to hide
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    
        return keyboardSize.cgRectValue.height
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        
        // if we're entering bottom text, move the image up so we can see our edits
        if textBotton.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification: notification as NSNotification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        // if we were entering bottom text, move the image back down to normal
        if textBotton.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.endEditing(true)
        return true
    }
    //Save Meme
    func save(memedImage: UIImage){
        let meme = Meme(textTop: textTop.text!, textBottom: textBotton.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    // MARK: - Actions
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
    //image from Photos Albums
    selectImage(sourceImage: UIImagePickerControllerSourceType.photoLibrary)
        
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
    //image from Camera
        selectImage(sourceImage: UIImagePickerControllerSourceType.camera)
    }
    
    @IBAction func shareBtn(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                //save image
                 self.save(memedImage: memedImage)
                //Dismiss the shareActivityViewController
                self.dismiss(animated: true, completion: nil)
                
            }
            
        }
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
            //Text Clear
            textTop.text = "Top"
            textBotton.text = "Bottom"
        
            //Disable Button Share
            btnShare.isEnabled = false
        
            if imagePickerView.image != nil {
            //Image Clear
            self.imagePickerView.image = nil
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}

