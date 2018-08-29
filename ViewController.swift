//
//  ViewController.swift
//  EMan
//
//  Created by Developer 1 on 29/06/2018.
//  Copyright © 2018 AppDev. All rights reserved.
//

import UIKit
import RevealingSplashView
import KASlideShow
import AASquaresLoading
import SCLAlertView


class ViewController: UIViewController, KASlideShowDelegate, KASlideShowDataSource, UITextFieldDelegate {
    func slideShow(_ slideShow: KASlideShow!, objectAt index: UInt) -> NSObject! {
        let ind = NSInteger(index)
        return slideImages[ind] as NSObject
        
    }
    
    func slideShowImagesNumber(_ slideShow: KASlideShow!) -> UInt {
        return UInt(slideImages.count)
    }
    
    @IBOutlet weak var enteredEventCode: UITextField!
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var slideShow: KASlideShow!
    
    var passcode = ""
    var event: Event!
    
    var slideImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureAALoading()
        
        enteredEventCode.delegate = self
        enteredEventCode.keyboardType = .numberPad
        
        whiteView.layer.shadowColor = UIColor.black.cgColor
        whiteView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        whiteView.layer.shadowRadius = 3.0
        whiteView.layer.shadowOpacity = 70
        
        let revealingSplashView = RevealingSplashView(iconImage: #imageLiteral(resourceName: "event_app_icon_v12"), iconInitialSize: CGSize(width: 74, height: 70), backgroundColor: UIColor(red: 27/255.0, green: 94/255.0, blue: 32/255.0, alpha: 1.0))
        
        revealingSplashView.animationType = SplashAnimationType.twitter
        
        //adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //starts animation
        revealingSplashView.startAnimation(){
            print("Completed")
            
        }
        
        slideImages = ["img3.png","img1.png","img5.png","img6.png","img8.png","img9.png","img11.png","img12.png","img13.png","img14.png","img15.png","img16.png","img17.png","img18.png","img19.png","img21.png","img22.png","img23.png"
            
        ]
        
        slideShow.datasource = self
        slideShow.delegate = self
        
        slideShow.delay = 3
        slideShow.transitionDuration = 1.0
        slideShow.transitionType = KASlideShowTransitionType.fade
        slideShow.imagesContentMode = .scaleAspectFill
        slideShow.add(KASlideShowGestureType.all)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        slideShow.start()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //KASlideShow delegate
    
    func kaSlideShowWillShowNext(slideshow: KASlideShow){
        NSLog("kaSlideShowWillShowNext")
    }
    
    func kaSlideShowWillShowPrevious(slideshow: KASlideShow){
        NSLog("kaSlideShowWillShowPrevious")
    }
    
    
    func kaSlideDidShowNext(slideshow: KASlideShow){
        NSLog("kaSlideDidShowNext")
    }
    
    func kaSlideShowDidShowPrevious(slideshow: KASlideShow){
        NSLog("kaSlideShowWillShowPrevious")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DashBoardViewController" {
        let dashBoardController = segue.destination as! DashBoardViewController
        dashBoardController.event = event
        dashBoardController.passcode = passcode
    }
    }
    
    @IBAction func eventAccessButton(_ sender: UIButton) {
        DispatchQueue.main.async {
            let OnBoardPage = self.storyboard?.instantiateViewController(withIdentifier: "showEventDashboard") as! OnBoardingViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = OnBoardPage
            
        }
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        //read values from textfield
        passcode = enteredEventCode.text!
        
        
        //check if required fields are not empty
        if (passcode.isEmpty)
        {
            _ = SCLAlertView(appearance: appearance).showError("Ooops!", subTitle: "Please input valid event code.")
        } else {
            validateEventPasscode()
        }
        
    }
    
    //MARK: Functions
    
    func configureAALoading() {
        self.view.squareLoading.color = UIColor (red: 0/255.0, green: 86/255.0, blue: 21/255.0, alpha: 1.0)
        self.view.squareLoading.backgroundColor = UIColor (red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.7)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let maxlength = 4
        let currentString: NSString = enteredEventCode.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxlength
        
   
    }
    
    func validateEventPasscode(){
        //Show Loading
        self.view.squareLoading.start(0.0)
        
        
        let api = APIService(APIKey: passcode)
        
        api.validatePasscode(passcode: passcode, successBlock: { (event) in
           
           if let eventDetails = event {
            
            guard eventDetails.deleteFlag == false else {
                
                _ = SCLAlertView(appearance: appearance).showError("Ooops!", subTitle: "Please enter a valid event passcode")
                
                self.view.squareLoading.stop(0.0)
                self.enteredEventCode.text = ""
                
                return
            }
           
            if (eventDetails.closedFlag == true && eventDetails.reopenFlag == false) {
                _ = SCLAlertView(appearance: appearance).showError("Closed Event", subTitle: "Please check the status of your event and try again")
                
                self.view.squareLoading.stop(0.0)
                self.enteredEventCode.text = ""
                return
            }

            // VALID PASSCODE AND NOT DELETED OR CLOSED EVENT
            
            self.event = event
            self.view.squareLoading.stop(0.0)
            
            self.performSegue(withIdentifier: "showEventDashboard", sender: self)
            
            self.enteredEventCode.text = ""
            return
            }
            
            
            
            
        }) { (error) in
            DispatchQueue.main.async{
                
                _ = SCLAlertView(appearance: appearance).showError("Network Error", subTitle: "Network Error:\(error)")
            }
            
            self.view.squareLoading.stop(0.0)
            self.enteredEventCode.text = ""
            
            return
        }
        }
            
          
}
            






