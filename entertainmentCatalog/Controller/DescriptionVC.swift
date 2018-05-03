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
        
        navigationItem.title = "Add description"
        
        addToCatalogBtn.bindToKeyboard()
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
    
    func saveToCoreData(completion: @escaping (_ completed: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let game = Game(context: managedContext)
        game.gamePoster = UIImagePNGRepresentation((gameInformation?.image!)!)
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
}

extension DescriptionVC: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.text == "                                                                      Description of the Game" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.black
            descriptionTextView.textAlignment = .left
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text == "" {
            descriptionTextView.text = "                                                                      Description of the Game"
            descriptionTextView.textAlignment = .center
            descriptionTextView.textColor = #colorLiteral(red: 0.7960784314, green: 0.7960784314, blue: 0.8196078431, alpha: 1)
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
