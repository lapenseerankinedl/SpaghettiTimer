//
//  TimerViewController.swift
//  SpaghettiTimer
//
//  Created by user180266 on 12/3/20.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var labelDisplay: UILabel!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    let dateFormatter: DateFormatter = DateFormatter()
    var receivedString = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        labelDisplay.text = receivedString
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
    }
    
    

}
