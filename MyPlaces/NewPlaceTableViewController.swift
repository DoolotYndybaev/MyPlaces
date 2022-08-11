//
//  NewPlaceTableViewController.swift
//  MyPlaces
//
//  Created by Doolot on 10/8/22.
//

import UIKit

class NewPlaceTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
        } else {
            view.endEditing(true)
        }
    }

}


// MARK: Text field delegate

extension NewPlaceTableViewController: UITextFieldDelegate {
    
    // Скрываем клавиатуру по нажатию на done
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
