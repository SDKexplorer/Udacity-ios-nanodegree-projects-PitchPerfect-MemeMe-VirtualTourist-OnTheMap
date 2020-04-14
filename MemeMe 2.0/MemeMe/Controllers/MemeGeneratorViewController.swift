//
//  ViewController.swift
//  MemeMe
//
//  Created by Marius Chelariu on 30/03/2020.
//  Copyright © 2020 Marius Chelariu. All rights reserved.
//

import UIKit

class MemeGeneratorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {

    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        NSAttributedString.Key.strokeColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]
    
    private var _image: UIImage? = nil
    var image: UIImage? {
        get{
            return _image
        }
        set(value) {
            _image = value
            let isEnable = value == nil ? false : true;

            shareButton.isEnabled = isEnable
            saveButton.isEnabled = isEnable
        }
    }
    
    
    
    // MARK: Outlets
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var pickImageButtonItem: UIBarButtonItem!
    @IBOutlet weak var imagePresenter: UIImageView!
    @IBOutlet weak var cameraButtonItem: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: Lifecycle Hooks
    
    override func viewDidAppear(_ animated: Bool) {
        styleTextField(topTextField, TextConstants.topText)
        styleTextField(bottomTextField, TextConstants.bottomText)
    }
    
    func styleTextField(_ textField: UITextField, _ defaultText: String){
        textField.text = defaultText
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotification()
    }

    // MARK: Actions
    
    @IBAction func pickImage(_ sender: Any) {
        pickFromSource(.photoLibrary)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        pickFromSource(.camera)
    }
    
    private func pickFromSource(_ source: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self;
        imagePickerController.sourceType = source;
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func save() {
        let memedImage = generateMemedImage()
        if let selectedImage = imagePresenter.image {
            let avc = UIActivityViewController(activityItems: [memedImage], applicationActivities: [])
            avc.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, memedImage: memedImage, originalImage: selectedImage)
                    MemeService.instance.addItem(meme)
                }
            }
            present(avc, animated: true, completion: nil)
        }
    }
    
    @IBAction func saveOnSession(){
        if let selectedImage = imagePresenter.image {
            let memedImage = generateMemedImage()
            let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, memedImage: memedImage, originalImage: selectedImage)
            MemeService.instance.addItem(meme)
            dismiss(animated: true) {
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "updateParent"), object: nil)
            }
        }
    }
    
    // MARK: ImagePickerDelegates
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage
        {
            self.image = image
            imagePresenter.image = image;
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePresenter.image = nil;
        self.image = nil
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: TextFieldDelegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Methods
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func generateMemedImage() -> UIImage {

        toggleNavBarToolBar(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        toggleNavBarToolBar(false)
        return memedImage
    }
    
    func toggleNavBarToolBar(_ value: Bool){
        self.navBar.isHidden = value
        self.toolBar.isHidden = value
    }
    // MARK: Event listeners
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: Keyboard handlers
    
    @objc func keyboardWillShow (_ notification: Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide (_ notification: Notification) {
        view.frame.origin.y = 0
    }

}

