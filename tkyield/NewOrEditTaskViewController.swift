//
//  EditTaskViewController.swift
//  tkyield
//
//  Created by Kevin on 8/30/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit

class NewOrEditTaskViewController: UIViewController {

    var action: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "New Task"
        let doneButton = UIBarButtonItem.init(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: nil)
        let cancelButton = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewOrEditTaskViewController.backButtonPressed))
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.leftBarButtonItem = cancelButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButtonPressed() {
        print(self.navigationController?.parent)
        self.dismiss(animated: true) { 
            print("DISMISSED")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
