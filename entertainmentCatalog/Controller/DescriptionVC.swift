//
//  DescriptionVC.swift
//  entertainmentCatalog
//
//  Created by Mokhamad Valid Kazimi on 30.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import CoreData

class DescriptionVC: UIViewController {
    // Outlets
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var releaseYearTextField: UITextField!
    @IBOutlet weak var genreTextfield: UITextField!
    @IBOutlet weak var addToCatalogBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    // Properties
    let gameGenres = ["Action", "Action-Adventure", "Adventure", "Role-Playing", "Simulation", "Strategy", "Sports"]
    
    var releaseYears: [String] = {
        var array = [String]()
        var i = 2020
        
        for y in 0..<50 {
            i -= 1
            array.append("\(i)")
        }
        
        return array
    }()
    
    var releaseYearPicker: UIPickerView?
    var genrePicker: UIPickerView?
    var selectedYear: String?
    var selectedGenre: String?
    var gameInformation: GameInfo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.delegate = self
        releaseYearTextField.delegate = self
        genreTextfield.delegate = self
        
        navigationItem.title = "Description"
        
        configureView()
        createReleaseYearPicker()
        createGenrePicker()
    }
    
    // Methods
    func configureView() {
        descriptionTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.clipsToBounds = true
        
        let addToCatalogBtn2 = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        let attributedTitle = NSAttributedString(string: "ADD TO CATALOG", attributes: [NSAttributedStringKey.font : UIFont(name: "AvenirNext-Bold", size: 22)!, NSAttributedStringKey.foregroundColor: UIColor.white])
        
        addToCatalogBtn2.backgroundColor = #colorLiteral(red: 0.2745098039, green: 0.8431372549, blue: 0.2431372549, alpha: 1)
        addToCatalogBtn2.setAttributedTitle(attributedTitle, for: .normal)
        addToCatalogBtn2.addTarget(self, action: #selector(handleAddToCatalogBtn2), for: .touchUpInside)
        
        descriptionTextView.inputAccessoryView = addToCatalogBtn2
        releaseYearTextField.inputAccessoryView = addToCatalogBtn2
        genreTextfield.inputAccessoryView = addToCatalogBtn2
        
        let tapViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
        tapViewRecognizer.numberOfTapsRequired = 1
        tapViewRecognizer.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tapViewRecognizer)
    }
    
    @objc func handleAddToCatalogBtn2() {
        doAddToCatalog()
    }
    
    @objc func handleViewTap() {
        view.endEditing(true)
    }
    
    func createReleaseYearPicker() {
        releaseYearPicker = UIPickerView()
        releaseYearPicker!.delegate = self
        releaseYearPicker!.dataSource = self
        releaseYearPicker!.backgroundColor = .white
        
        releaseYearTextField.inputView = releaseYearPicker
    }
    
    func createGenrePicker() {
        genrePicker = UIPickerView()
        genrePicker!.delegate = self
        genrePicker!.dataSource = self
        genrePicker!.backgroundColor = .white
        
        genreTextfield.inputView = genrePicker
    }
    
    func doAddToCatalog() {
        if let descriptionText = descriptionTextView.text, descriptionText != "", descriptionText != "                                                                      Description of the Game" {
            if let releaseYearText = releaseYearTextField.text, releaseYearText != "" {
                if let genreText = genreTextfield.text, genreText != "" {
                    gameInformation?.description = descriptionText
                    gameInformation?.releaseYear = releaseYearText
                    gameInformation?.genre = genreText
                    
                    saveToCoreData { (success) in
                        if success {
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                } else {
                    emptyFieldAlert()
                }
            } else {
                emptyFieldAlert()
            }
        } else {
            emptyFieldAlert()
        }
    }
    
    func saveToCoreData(completion: @escaping (_ completed: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let game = Game(context: managedContext)
        game.gamePoster = UIImageJPEGRepresentation((gameInformation?.image)!, 0.5)
        game.gameTitle = gameInformation?.title
        game.gameDescription = gameInformation?.description
        game.gameRealeaseYear = gameInformation?.releaseYear
        game.gameGenre = gameInformation?.genre
        
        do {
            if managedContext.hasChanges {
                try managedContext.save()
                print("!!!!!!! Successfully saved data.")
                completion(true)
            }
        } catch {
            debugPrint("!!!!!!! Failed to save data: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func emptyFieldAlert() {
        let alert = UIAlertController(title: "Whoops...", message: "Be sure to fill out all fields before adding a new item to the Catalog.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Actions
    @IBAction func addToCatalog(_ sender: Any) {
        doAddToCatalog()
    }
}

extension DescriptionVC: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "                                                                      Description of the Game" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
            descriptionTextView.textAlignment = .left
        }
        addToCatalogBtn.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            descriptionTextView.text = "                                                                      Description of the Game"
            descriptionTextView.textAlignment = .center
            descriptionTextView.textColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.8196078431, alpha: 1)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.addToCatalogBtn.isHidden = false
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "" {
            if textField == releaseYearTextField {
                releaseYearTextField.text = releaseYears[0]
            } else if textField == genreTextfield {
                genreTextfield.text = gameGenres[0]
            }
        }
        
        if view.frame.size.width == 320 {
            scrollView.setContentOffset(CGPoint(x: 0, y: releaseYearTextField.frame.origin.y / 2), animated: true)
        }
        addToCatalogBtn.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if view.frame.size.width == 320 {
            scrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: view.frame.size.width, height: 10), animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            self.addToCatalogBtn.isHidden = false
        }
    }
}

extension DescriptionVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == releaseYearPicker {
            return releaseYears.count
        } else {
            return gameGenres.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == releaseYearPicker {
            return releaseYears[row]
        } else {
            return gameGenres[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePicker {
            selectedGenre = gameGenres[row]
            genreTextfield.text = selectedGenre
        } else if pickerView == releaseYearPicker {
            selectedYear = releaseYears[row]
            releaseYearTextField.text = selectedYear
        }
    }
}
