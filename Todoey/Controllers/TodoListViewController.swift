//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        print(dataFilePath)
        
       
        
        loadItems()
        

    }
    //MARK - Tableview Datasource Methods
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
            //Ternary operator ->
            //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
 
            // above line replaces below code
            //        if item.done == true{
            //            cell.accessoryType = .checkmark
            //        }
            //        else{
            //            cell.accessoryType = .none
            //        }
                    
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

            //The above line replaces all this code below
            //   if itemArray[indexPath.row].done == false{
            //   itemArray[indexPath.row].done = true
            //
            //        }else{
            //            itemArray[indexPath.row].done = false
            //        }
        saveItems()
       
       
        tableView.deselectRow(at: indexPath, animated: true)
    }
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the Add Item on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
           
            self.saveItems()
           
           
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    // MARK: Model Manipulation Methods
    func saveItems(){
        
        let encoder = PropertyListEncoder()
                   do {
                       let data = try encoder.encode(itemArray)
                       try data.write(to: dataFilePath!)
                   }
                   catch{
                           print("Error encoding item array \(error)")
                   }
                   self.tableView.reloadData()
    }
    func loadItems(){
       if let data = try? Data(contentsOf: dataFilePath!){
            
        let decoder = PropertyListDecoder()
        do{
               itemArray = try decoder.decode([Item].self, from: data)
        }catch{
            print("Error decoding item array \(error)")
        }
     
        
        }
    }
}

