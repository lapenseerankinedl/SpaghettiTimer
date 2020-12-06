//
//  ViewController.swift
//  SpaghettiTimerApp
//
//  Created by user180266 on 12/6/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableData: UITableView!
    @IBOutlet weak var addButton: UIButton!
    var mainArray = ["Homework 1"]
    //var detailArray = ["Worked: 0h25m"]
    var imageArray = ["river1.jpg"]
    let cellID = "customCell"
    var selectedItem = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading th
        tableData.delegate = self
        tableData.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID) as! TableViewCell
        cell.mainText?.text = self.mainArray[indexPath.row]
        //cell.detailText?.text = self.detailArray[indexPath.row]
        cell.detailText?.text = UserDefaults.string(forKey: "totalTime")
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
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
        selectedItem = mainArray[indexPath.row]
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
            UserDefaults.standard.set(savedText.text ?? "default", forKey: "name")
            UserDefaults.standard.set("Worked: 0h0m", forKey: "totalTime")
            UserDefaults.standard.set("", forKey: "icon")                                                                 
            self.mainArray.insert(savedText.text ?? "default", at: location)
            //self.detailArray.insert("Worked: 0h0m", at: location)
            self.imageArray.insert("river1.jpg", at: location)
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
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "totalTime")
            UserDefaults.standard.set("", forKey: "icon")
            self.mainArray.remove(at: indexPath.row)
            //self.detailArray.remove(at: indexPath.row)
            self.imageArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        })
        return [deleteAction, addAcion]
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        self.displayAlert(location: 0)
    }
}

