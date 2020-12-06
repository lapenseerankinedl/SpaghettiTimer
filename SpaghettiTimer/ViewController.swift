//
//  ViewController.swift
//  SpaghettiTimer
//
//  Created by user180266 on 12/3/20.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableData: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var mainArray = ["Shuttle bus", "Hierarchy", "Exchange"]
    var detailArray = ["Worked: 0h0m", "Worked: 0h0m", "Worked: 0h0m"]
    var imageArray = ["river1.jpg", "river1.jpg", "river1.jpg"]
    let cellID = "customCell"
    var selectedItem = ""
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject]()
    
    struct STimer {
        var name: String = "Example timer"
        var icon: String = "river1.jpg"
        var totalTime: Double = 0.0
    }
    
    var timerArray = [STimer()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading th
        tableData.delegate = self
        tableData.dataSource = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TableViewCell
        // call fetchData
        
        cell.mainText?.text = self.timerArray[indexPath.row].name
        cell.detailText?.text = String(self.timerArray[indexPath.row].totalTime)
        cell.imageView?.image = UIImage(named: self.timerArray[indexPath.row].icon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        let selectedItem = mainArray[indexPath.row]
        let alert = UIAlertController(title: "Your Choice", message: "\(selectedItem)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action -> Void in })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        */
        selectedItem = timerArray[indexPath.row].name
        performSegue(withIdentifier: "linkToTimer", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! TimerViewController
        nextVC.receivedString = "\(selectedItem)"
    }
    
    func displayAlert(location: Int) {
        let alert = UIAlertController(title: "Add", message: "New Timer", preferredStyle: .alert)
        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "Timer name here"})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action -> Void in
            let savedText = alert.textFields![0] as UITextField
            self.timerArray.insert(STimer(name: (savedText.text ?? "default"), icon: "river1.jpg", totalTime: 0.0 ), at: location)
            
            self.addData(name: savedText.text ?? "default", icon: "river1.jpg", recordedSessions: "   ", savedTime: 0.0, totalTime: 0.0)
            self.tableData.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {action -> Void in })
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let addAcion = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "Add", handler: {(action: UITableViewRowAction, indexPath: IndexPath) in
            self.displayAlert(location: indexPath.row)
        })
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.destructive, title: "Delete", handler: {(action: UITableViewRowAction, indexPath: IndexPath) in
            let deleteItem = self.timerArray[indexPath.row].name
            for item in listArray {
                if item.value(forKey: "name") as! String == deleteItem {
                    dataManager.delete(item)
                }
            }
            do {
                try self.dataManager.save()
            } catch {
                print("Error deleting data")
            }                                                                                                            
            self.timerArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        })
        return [deleteAction, addAcion]
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.displayAlert(location: 0)
    }
    
    func addData(name: String, icon: String, recordedSessions: String, savedTime: Double, totalTime: Double) {
        let newEntity = NSEntityDescription.insertNewObject(forEntityName: "STimer", into: dataManager)
        newEntity.setValue(name, forKey: "name")
        newEntity.setValue(icon, forKey: "icon")
        newEntity.setValue(recordedSessions, forKey: "recordedSessions")
        newEntity.setValue(savedTime, forKey: "savedTime")
        newEntity.setValue(totalTime, forKey: "totalTime")
        do {
            try self.dataManager.save()
            listArray.append(newEntity)
        } catch {
            print ("Error saving data")
        }
        fetchData()
    }
    
    func fetchData() {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "STimer")
        do {
            let result = try dataManager.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            var i = 0
            for item in listArray {
                let name = item.value(forKey: "name") as! String
                let totalTime = item.value(forKey: "totalTime") as! Double
                let icon = item.value(forKey: "icon") as! String
                timerArray[i].name = name
                timerArray[i].totalTime = totalTime
                timerArray[i].icon = icon
                i += 1
            }
        } catch {
            print("Error retrieving data")
        }
    }}

