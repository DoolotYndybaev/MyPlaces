//
//  MainTableViewController.swift
//  MyPlaces
//
//  Created by Doolot on 8/8/22.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let restaurantNames = ["Burger Heroes", "Kitchen", "Bonsai", "Дастархан", "X.O", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Love&Life", "Индокитай", "Балкан Гриль", "Вкусные истории", "Классик", "Шок", "Бочка"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantNames.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
 
        cell.textLabel?.text = restaurantNames[indexPath.row]
        cell.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}