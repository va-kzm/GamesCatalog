//
//  DetailVC.swift
//  entertainmentCatalog
//
//  Created by Mokhamad Valid Kazimi on 03.05.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    // Outlets
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameTitleLbl: UILabel!
    @IBOutlet weak var gameDescriptionLbl: UILabel!
    @IBOutlet weak var gameReleaseYearLbl: UILabel!
    @IBOutlet weak var gameGenreLbl: UILabel!
    
    // Properties
    var game: Game?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameImageView.image = UIImage(data: (game?.gamePoster)!)
        gameTitleLbl.text = game?.gameTitle
        gameDescriptionLbl.text = game?.gameDescription
        gameReleaseYearLbl.text = game?.gameRealeaseYear
        gameGenreLbl.text = game?.gameGenre
    }
}
