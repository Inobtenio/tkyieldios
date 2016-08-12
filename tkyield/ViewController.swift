//
//  ViewController.swift
//  tkyield
//
//  Created by Kevin on 8/9/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.Alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
        print("OK")
    };
    
    
    @IBAction func loginButton(sender: UIButton) {
        if (sender as! NSObject == self.loginButton ){
            NetworkManager.sharedInstance.makeAuthRequest(emailInput.text!, password: passwordInput.text!, completion: { (errorMessage) in
                if (errorMessage.empty()){
                    self.performSegueWithIdentifier("loginSegue", sender: self)
                } else {
                    self.alertController.title = errorMessage.message == nil ? "Error" : errorMessage.message
                    self.alertController.message = errorMessage.reason
                    self.presentViewController(self.alertController, animated: true, completion: nil)
                }
            })
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertController.addAction(self.okAction)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

