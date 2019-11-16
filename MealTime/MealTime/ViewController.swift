//
//  ViewController.swift
//  MealTime
//
//  Created by wtildestar on 17/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var array = [Date]()
    var context: NSManagedObjectContext!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableView.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My happy meal time"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        let date = array[indexPath.row]
        
        cell!.textLabel!.text = dateFormatter.string(from: date)
        return cell!
    }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let date = Date()
        array.append(date)
        tableView.reloadData()
    }


}

