//
//  TimerViewController.swift
//  SpaghettiTimer
//
//  Created by user180266 on 12/3/20.
//

import UIKit
import Foundation
import CoreData

class TimerViewController: UIViewController {

    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var workButton: UIButton!
    @IBOutlet weak var sBreakButton: UIButton!
    @IBOutlet weak var lBreakButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textViewDisplay: UITextView!
    
    var resetTime = 0
    var timer = Timer()
    let dateFormatter: DateFormatter = DateFormatter()
    var receivedString = ""
    var buttonPressed = ""
    var currentTime = 0
    var hitOne = false
    
    var dataManager : NSManagedObjectContext!
    var listArray = [NSManagedObject] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelDisplay.text = receivedString
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        textViewDisplay.text?.removeAll()
        fetchData()
    }
    
    @IBAction func workButtonPressed(_ sender: UIButton) {
        if (!timer.isValid) {
            workButton.tintColor = UIColor.white
            workButton.backgroundColor = UIColor.blue
            sBreakButton.tintColor = UIColor.blue
            sBreakButton.backgroundColor = UIColor.white
            lBreakButton.tintColor = UIColor.blue
            lBreakButton.backgroundColor = UIColor.white
            buttonPressed = "wButton"
        }
            
    }
    
    @IBAction func sBreakButtonPressed(_ sender: UIButton) {
        if (!timer.isValid) {
            sBreakButton.tintColor = UIColor.white
            sBreakButton.backgroundColor = UIColor.blue
            workButton.tintColor = UIColor.blue
            workButton.backgroundColor = UIColor.white
            lBreakButton.tintColor = UIColor.blue
            lBreakButton.backgroundColor = UIColor.white
            buttonPressed = "sButton"
        }
        
    }
    
    @IBAction func lBreakButtonPressed(_ sender: UIButton) {
        if (!timer.isValid) {
            lBreakButton.tintColor = UIColor.white
            lBreakButton.backgroundColor = UIColor.blue
            sBreakButton.tintColor = UIColor.blue
            sBreakButton.backgroundColor = UIColor.white
            workButton.tintColor = UIColor.blue
            workButton.backgroundColor = UIColor.white
            buttonPressed = "lButton"
        }
        
    }
    
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if (buttonPressed == "") {
            showAlert(messageText: "Please choose a timer option: Work, Short Break, Long Break")
        }
        else {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TimerViewController.updateTimer), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        timer.invalidate()
        // TODO:
        // when timer is stopped
        // save current left time
        // and do not print to screen
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        // TODO:
        // do not save time
        // possibly delete the saved leftover time when the timer was stopper
        timer.invalidate()
        myDatePicker.countDownDuration = TimeInterval(resetTime)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
 
    }
    
    @objc func updateTimer() {
        myDatePicker.countDownDuration -= 1
        if (hitOne == true) {
            timer.invalidate()
            // TODO:
            // add alert here and/or sound
            hitOne = false
            showAlert(messageText: "Timer has finished")
            // save the time when it runs out
            // and print it to the screen
            
            
        }
        if (myDatePicker.countDownDuration == 60) {
            hitOne = true
        }
    }
    
    func showAlert(messageText: String) {
        let alert = UIAlertController(title: "Timer", message: "\(messageText)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {action -> Void in
            
        })
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchData() {
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "STimer")
        do {
            let result = try dataManager.fetch(fetchRequest)
            listArray = result as! [NSManagedObject]
            for item in listArray {
                let name = item.value(forKey: "name") as! String
                let recordedSession = item.value(forKey: "recordedSessions") as! String
                textViewDisplay.text! += name + " " + recordedSession + ", "
            }
        } catch {
            print("Error retrieving data")
        }
    }
    
}
