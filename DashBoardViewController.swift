//
//  DashBoardViewController.swift
//  EMan
//
//  Created by Developer 1 on 01/08/2018.
//  Copyright © 2018 AppDev. All rights reserved.
//

import UIKit
import SCLAlertView
import Alamofire

class DashBoardViewController: UIViewController {
    
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    var passcode: String!
    var event: Event!

    override func viewDidLoad() {
        super.viewDidLoad()
    
       configureAALoading()
       
        guard event != nil,
            passcode != nil else {
                _ = SCLAlertView(appearance: appearance).showError("No Event Details", subTitle: "There's no event details, please logout and try again")
                return
                }
      
        showEventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    //EVENTS : FUNCTIONS
    
    func configureAALoading() {
        self.view.squareLoading.color = UIColor(red: 80/255.0, green: 187/255.0, blue: 113/255.0, alpha: 1.0)
        self.view.squareLoading.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
    }
    
    func showEventDetails() {

            DispatchQueue.main.async{
                self.eventNameLabel.text =  "\(self.event.name.uppercased())"
                self.locationLabel.text =  "\(self.event.location.uppercased())"
            
                if let dateStringFromDate = getFormattedStringFromDate(date: (self.event.startDateTime), formatString: "MMMM dd, yyyy/ hh:mm a") {
                self.dateTimeLabel.text = dateStringFromDate
            } else {
                self.dateTimeLabel.text = "-"
            }
        }
       
        
            
        }
    

    @IBAction func logOutButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let WelcomePage = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = WelcomePage
        
    }
    }
   


}
