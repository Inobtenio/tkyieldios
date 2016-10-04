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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.alert)
    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
        print("OK")
    };
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if (sender as NSObject == self.loginButton ){
            self.activityIndicator.startAnimating()
            passwordInput.resignFirstResponder()
            emailInput.resignFirstResponder()
            UIApplication.shared.beginIgnoringInteractionEvents()
            NetworkManager.sharedInstance.makeAuthRequest(emailInput.text!, password: passwordInput.text!, completion: { (errorMessage) in
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                if (errorMessage.empty()){
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                } else {
                    self.alertController.title = errorMessage.message == nil ? "Error" : errorMessage.message
                    self.alertController.message = errorMessage.reason
                    self.present(self.alertController, animated: true, completion: nil)
                }
            })
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true;
        self.alertController.addAction(self.okAction)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

