//
//  TaskViewController.swift
//  tkyield
//
//  Created by Kevin on 8/15/16.
//  Copyright © 2016 Kevin. All rights reserved.
//

import UIKit
class TaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    var task = TimeSheet(json: [:])
    var pickerDataSource = ["one", "two", "three", "four", "five", "six"]
    @IBOutlet weak var projectPicker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.projectPicker.dataSource = self;
//        self.projectPicker.delegate = self;
//        projectPicker.userInteractionEnabled = false
        let backButton = UIBarButtonItem()
        backButton.target = self
        backButton.action = #selector(TaskViewController.backButtonPressed)
        backButton.title = "<  Back"
        self.navigationItem.leftBarButtonItem = backButton
        let editButton = UIBarButtonItem.init(title: "Edit", style: UIBarButtonItemStyle.done, target: self, action: #selector(TaskViewController.goToEditTaskView))
        self.navigationItem.rightBarButtonItem = editButton
        self.navigationItem.title = task.task_name!
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func goToEditTaskView() -> Void {
        print("SEGUE?")
        self.performSegue(withIdentifier: "editTask", sender: self)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row]
    }
    
    func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
