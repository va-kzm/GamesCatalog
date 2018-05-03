//
//  CatalogVC.swift
//  entertainmentCatalog
//
//  Created by Mokhamad Valid Kazimi on 17.04.2018.
//  Copyright © 2018 Mokhamad Valid Kazimi. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class CatalogVC: UIViewController {
    // Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var welcomeView: UIView!
    
    // Properties
    var games = [Game]()
    var filteredGames = [Game]()
    let searchController = UISearchController(searchResultsController: nil)
    
    let applicationsDocumentsDirectory: URL = {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        welcomeView.isHidden = false
        
        configureView()
        print(applicationsDocumentsDirectory)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchGameInfoData()
        tableView.reloadData()
    }
    
    // Methods
    func configureView() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
    }
    
    func searchBarIsEmpty() -> Bool {
        return (searchController.searchBar.text?.isEmpty)!
    }
    
    func filterContentForSearch(_ searchText: String, scope: String = "All") {
        filteredGames.removeAll()
        
        let titleFilter = games.filter({ return ($0.gameTitle?.lowercased().contains(searchText.lowercased()))!})
        let descriptionFilter = games.filter({ return ($0.gameDescription?.lowercased().contains(searchText.lowercased()))!})
        let releaseYearFilter = games.filter({ return ($0.gameRealeaseYear?.lowercased().contains(searchText.lowercased()))!})
        let genreFilter = games.filter({ return ($0.gameGenre?.lowercased().contains(searchText.lowercased()))!})
        
        let allFilter = titleFilter + descriptionFilter + releaseYearFilter + genreFilter
        
        print("!!!!!!! title \(titleFilter.count)")
        print("!!!!!!! description \(descriptionFilter.count)")
        print("!!!!!!! release \(releaseYearFilter.count)")
        print("!!!!!!! genre \(genreFilter.count)")
        
//        for i in titleFilter {
//            filteredGames.append(i)
//        }
//
//        for i in descriptionFilter {
//            if !filteredGames.contains(i) {
//                filteredGames.append(i)
//            }
//        }
//
//        for i in releaseYearFilter {
//            if !filteredGames.contains(i) {
//                filteredGames.append(i)
//            }
//        }
//
//        for i in genreFilter {
//            if !filteredGames.contains(i) {
//                filteredGames.append(i)
//            }
//        }
        
        for i in allFilter {
            if !filteredGames.contains(i) {
                filteredGames.append(i)
            }
        }
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func fetchGameInfoData() {
        fetch { (success) in
            if self.games.count >= 1 {
                self.welcomeView.isHidden = true
            } else {
                self.welcomeView.isHidden = false
            }
        }
    }
    
    func fetch(completion: @escaping (_ completed: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Game>(entityName: "Game")
        
        do {
            games = try managedContext.fetch(fetchRequest)
            print("Successfully fetched data.")
            completion(true)
        } catch {
            debugPrint(error.localizedDescription)
            completion(false)
        }
    }
    
    func deleteGameInfoData(atIndexpath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        managedContext.delete(games[indexPath.row])
        
        do {
            try managedContext.save()
            print("Successfully deleted this shit.")
        } catch {
            debugPrint("Couldn't save data: \(error.localizedDescription)")
        }
    }
}

extension CatalogVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredGames.count
        } else {
            return games.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CATALOG_CELL_ID, for: indexPath) as! CatalogCell
        
        if isFiltering() {
            cell.configureCell(withGame: filteredGames[indexPath.row])
        } else {
            cell.configureCell(withGame: games[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: DETAIL_VC_ID) as! DetailVC
        
        if isFiltering() {
            controller.game = filteredGames[indexPath.row]
        } else {
            controller.game = games[indexPath.row]
        }
        
        controller.navigationItem.title = "Game Information"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { (_, indexPath) in
            self.deleteGameInfoData(atIndexpath: indexPath)
            self.fetchGameInfoData()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
        
        return [deleteAction]
    }
}

extension CatalogVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearch(searchController.searchBar.text!)
    }
}
