//
//  TimerViewController.swift
//  SpaghettiTimerApp
//
//  Created by user180266 on 12/3/20.
//

import UIKit

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
    var date = ""
    var time = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelDisplay.text = receivedString
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    @IBAction func workButtonPressed(_ sender: UIButton) {
        if (!timer.isValid) {
            workButton.tintColor = UIColor.white
            workButton.backgroundColor = UIColor.blue
            sBreakButton.tintColor = UIColor.blue
            sBreakButton.backgroundColor = UIColor.white
            lBreakButton.tintColor = UIColor.blue
            lBreakButton.backgroundColor = UIColor.white
            buttonPressed = "Work"
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
            buttonPressed = "SBreak"
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
            buttonPressed = "LBreak"
        }
        
    }
    
    
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        if (buttonPressed == "") {
            showAlert(messageText: "Please choose a timer option: Work, Short Break, Long Break")
        }
        else {
            time = myDatePicker.countDownDuration
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
            let selectedDate: String = dateFormatter.string(
            saveData()
            
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
    
    func saveData() {
        let selectedDate: String = dateFormatter.string(from: myDatePicker.date)
        let timeString = "0h" + (time/60) + "m"
        let sessionString = selectedDate + "  " + buttonPressed + "  " + timeString
        UserDefaults.standard.set(timeString, forKey: "totalTime")
        UserDefaults.standard.set(, forKey: "recordedSessions")
    }
    
}
