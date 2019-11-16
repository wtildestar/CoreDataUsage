//
//  TableViewController.swift
//  CoreDataUsage
//
//  Created by wtildestar on 12/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var toDoItems: [Task] = []
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        let ac = UIAlertController(title: "Добавить задачу", message: "Добавить новую задача", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ок", style: .default) { action in
            let textField = ac.textFields?[0]
            self.saveTask(taskToDo: (textField?.text)!)
//            self.toDoItems.insert((textField?.text)!, at: 0)
            self.tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Отмена", style: .default, handler: nil)
        ac.addTextField { textField in
            
        }
        
        ac.addAction(ok)
        ac.addAction(cancel)
        
        present(ac, animated: true, completion: nil)
        
    }
    
    func saveTask(taskToDo: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // задаем контекст
        let context = appDelegate.persistentContainer.viewContext
        // задаем сущность
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        //  создаем сам объект который хотим сохранить
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task
        // установим значение для taskObject
        taskObject.taskToDo = taskToDo
        // сохраняем контекст для сохранение объекта
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("Saved. good.")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // задаем контекст
        let context = appDelegate.persistentContainer.viewContext
        // делаем запрос по Task сущности
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = toDoItems[indexPath.row]
        cell.textLabel?.text = task.taskToDo

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
