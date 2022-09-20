//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Doolot on 8/8/22.
//

import UIKit
import RealmSwift

class MainTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredPlaces: Results<Place>!
    private var places: Results<Place>!
    private var ascendingSorting = true
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        places = realm.objects(Place.self)
        
        // Setup the search controller
        
        // Присваивая этому свойстве значение self мы тем самым говорим что получателем информации об изменении текста в поисковой строке должен быть наш класс
        searchController.searchResultsUpdater = self
        
        // По умолчанию вьюконтроллер с результатами поиска не позволяет взаимодействовать с отображаемым контентом. И если присвоит ей значение false то это позволит нам взаимодействовать с этим вьюконтроллером как с основным.
        searchController.obscuresBackgroundDuringPresentation = false
        
        // Название для нашей строки поиска
        searchController.searchBar.placeholder = "Search"
        
        // Строка поиска будет интегрирована в наш навигейшн бар
        navigationItem.searchController = searchController
        
        //  Позволяет отпустить строку поиска при переходе на другой экран
        definesPresentationContext = true
        
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        return places.isEmpty ? 0 : places.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        var place = Place()
        
        if isFiltering {
            place = filteredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }
        
//        let place = places[indexPath.row]
        
        cell.nameLabel?.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        
        cell.imageOfPlace.image = UIImage(data: place.imageData!)
        
        
        cell.imageOfPlace?.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace?.clipsToBounds = true
        
        return cell
    }
    
    // MARK: TableView Delegate
    
    // Метод преднозначен для нескольких UIContextualAction
    //    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    //        let place = places[indexPath.row]
    //
    //        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
    //            StorageManager.deleteObject(place)
    //            tableView.deleteRows(at: [indexPath], with: .automatic)
    //        }
    //        return UISwipeActionsConfiguration(actions: [deleteAction])
    //    }
    // А этот предназначен чтобы отобразить парочку действий
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let place = places[indexPath.row]
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    //  MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let place: Place
            if isFiltering {
                place = filteredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            let newPlaceVC = segue.destination as! NewPlaceTableViewController
            newPlaceVC.currentPlace = place
        }
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        
        guard let newPlaceVC = segue.source as? NewPlaceTableViewController else { return }
        
        newPlaceVC.savePlace()
        
        tableView.reloadData()
        
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date")
        } else {
            places = places.sorted(byKeyPath: "name")
        }
        
        tableView.reloadData()
    }
    @IBAction func reversedSorting(_ sender: Any) {
        
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "AZ")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "ZA")
        }
        sorting()
    }
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
    }
}

// MARK: protocol UISearchResultsUpdating

extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    private func filterContentForSearchText(_ searchText: String) {
        
        // Сортировка из документации Realm
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText)
        
        tableView.reloadData()
    }
}
