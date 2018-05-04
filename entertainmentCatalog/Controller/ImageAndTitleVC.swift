//
//  ImageAndTitleVC.swift
//  entertainmentCatalog
//
//  Created by Mokhamad Valid Kazimi on 28.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit

class ImageAndTitleVC: UIViewController {
    // Outlets
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // Properties
    var gameInformation = GameInfo()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        imagePicker.delegate = self
        titleTextField.delegate = self
        //nextBtn.bindToKeyboard()
    }
    
    // Methods
    func configureView() {
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        tapImageRecognizer.numberOfTapsRequired = 1
        tapImageRecognizer.numberOfTouchesRequired = 1
        gameImageView.addGestureRecognizer(tapImageRecognizer)
        
        navigationItem.title = "Image and title"
        
        let nextBtn2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let attributedTitle = NSAttributedString(string: "NEXT", attributes: [NSAttributedStringKey.font : UIFont(name: "AvenirNext-Bold", size: 22)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        
        nextBtn2.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.8431372549, blue: 0.2431372549, alpha: 1)
        nextBtn2.setAttributedTitle(attributedTitle, for: .normal)
        nextBtn2.addTarget(self, action: #selector(handleNextBarBtnItem), for: .touchUpInside)

        titleTextField.inputAccessoryView = nextBtn2
        
        let tapViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        tapViewRecognizer.numberOfTapsRequired = 1
        tapViewRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapViewRecognizer)
    }
    
    @objc func handleImageTap() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func handleNextBarBtnItem() {
        if let titleText = titleTextField.text, titleText != "" {
            let controller = storyboard?.instantiateViewController(withIdentifier: DESCRIPTION_VC_ID) as! DescriptionVC
            gameInformation.title = titleText
            gameInformation.image = gameImageView.image
            controller.gameInformation = gameInformation
            controller.navigationItem.backBarButtonItem?.title = "Back"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let alert = UIAlertController(title: "A Game with no name?", message: "You probably forgot to add the name of the game 🤓", preferredStyle: .alert)
            let action = UIAlertAction(title: "Maybe", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func handleViewTap() {
        if view.frame.size.width == 320 {
            view.endEditing(true)
        }
    }
    
    // Actions
    @IBAction func toNextStep(_ sender: Any) {
        if let titleText = titleTextField.text, titleText != "" {
            let controller = storyboard?.instantiateViewController(withIdentifier: DESCRIPTION_VC_ID) as! DescriptionVC
            gameInformation.title = titleText
            gameInformation.image = gameImageView.image
            controller.gameInformation = gameInformation
            controller.navigationItem.backBarButtonItem?.title = "Back"
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let alert = UIAlertController(title: "A Game with no name?", message: "You probably forgot to add the name of the game 🤓", preferredStyle: .alert)
            let action = UIAlertAction(title: "Maybe", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ImageAndTitleVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            gameImageView.contentMode = .scaleAspectFill
            gameImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageAndTitleVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if view.frame.size.width == 320 {
            scrollView.setContentOffset(CGPoint(x: 0, y: titleTextField.frame.origin.y / 2), animated: true)
        }
        nextBtn.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if view.frame.size.width == 320 {
            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50), animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            self.nextBtn.isHidden = false
        }
    }
}
