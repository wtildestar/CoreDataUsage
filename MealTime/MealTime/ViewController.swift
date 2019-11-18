//
//  ViewController.swift
//  MealTime
//
//  Created by Ivan Akulov on 10/11/16.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    var context: NSManagedObjectContext!
    @IBOutlet weak var tableView: UITableView!
    var array = [Date]()
    
    var person: Person!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let personName = "Alexey"
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", personName)
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // упрощенная форма записи
                person = Person(context: context)
                person.name = personName
                try context.save()
            } else {
                person = results.first
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // если meals равен nil то мы возвращаем один ряд
        guard let meals = person.meals else { return 1 }
        
        
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        guard let meal = person.meals?[indexPath.row] as? Meal,
            let mealDate = meal.date else { return cell! }
        
        cell!.textLabel!.text = dateFormatter.string(from: mealDate)
        return cell!
    }
    
    @IBAction func addButtonPressed(_ sender: AnyObject) {
        
        let meal = Meal(context: context)
        meal.date = Date() // присваиваем текущую дату и время
        
        let meals = person.meals?.mutableCopy() as? NSMutableOrderedSet // сделали копию сета
        meals?.add(meal)
        person.meals = meals
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), userInfo: \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    // метод позволяет производить действия с ячейкой
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Получаем объект который хотим удалить
        guard let mealToDelete = person.meals?[indexPath.row] as? Meal,
            editingStyle == .delete else { return }
        
        context.delete(mealToDelete)
        
        do {
            try context.save()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch let error as NSError {
            print("Error: \(error), description: \(error.userInfo)")
        }
        
    }
    
}

