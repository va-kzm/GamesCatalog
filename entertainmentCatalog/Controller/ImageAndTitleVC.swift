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
    
    // Properties
    var gameInformation = GameInfo()
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        imagePicker.delegate = self
        nextBtn.bindToKeyboard()
    }
    
    // Remove backBarButtonItem.title from the next viewController.
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.title = "Add image and title"
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationItem.title = "Back"
//    }
    
    // Methods
    func configureView() {
        let tapImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTap))
        tapImageRecognizer.numberOfTapsRequired = 1
        tapImageRecognizer.numberOfTouchesRequired = 1
        gameImageView.addGestureRecognizer(tapImageRecognizer)
        
        navigationItem.title = "Add image and title"
    }
    
    @objc func handleImageTap() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
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
