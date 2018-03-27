//
//  DetailViewController.swift
//  DeadStick
//
//  Created by Hal W. Dale, Jr. on 11/17/17.
//  Copyright © 2017 Hal W. Dale, Jr. All rights reserved.
//

import UIKit

// Class definition
class DetailViewController: UITableViewController {
    
    // Data passed from Master View Controller.
    var deadstick: DeadStick?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Recieve data from Master View Controller and update text fields.
        if let deadstick = deadstick {
            navigationItem.title = "Aircraft"
            aircraftTextField.text = deadstick.aircraft
            gSpeedTextField.text = String(deadstick.gSpeed ?? 0)
            gRatioTextField.text = String(deadstick.gRatio ?? 0)
            sAltitudeTextField.text = String(deadstick.sAltitude ?? 0)
            activateButton.isSelected = deadstick.activated
        }
        updateSaveButtonState()
    }
    
    
    // Connect text fields.
    @IBOutlet weak var aircraftTextField: UITextField!
    @IBOutlet weak var gSpeedTextField: UITextField!
    @IBOutlet weak var gRatioTextField: UITextField!
    @IBOutlet weak var sAltitudeTextField: UITextField!
    @IBOutlet weak var activateButton: UIButton!
    
    // Outlet for save & cancel buttons.
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // Mark: UITextFieldDelegate section.
    
    // Activate or deactivate aircraft button.
    @IBAction func activateButtonTapped(_ sender: UIButton) {
        activateButton.isSelected = !activateButton.isSelected
    }
    
    // Disable the save button if aircraft text field is empty.
    func updateSaveButtonState() {
        let text = aircraftTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    @IBAction func textEditingChanged(_ sender: Any) {
        updateSaveButtonState()
    }
    
    // Remove keyboard when leaving field.
    @IBAction func returnPressed(_ sender: UITextField) {
        aircraftTextField.resignFirstResponder()
    }
    
    // Mark: Navigation Methods
    
    // Save text field data, segue and pass data to Master View Controller.
    override func prepare(for segue: UIStoryboardSegue, sender:
        Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveUnwind" else { return }
        
        let aircraft = aircraftTextField.text
        let gSpeed = Int(gSpeedTextField.text ?? "") ?? 0
        let gRatio = Double(gRatioTextField.text ?? "") ?? 0
        let sAltitude = Int(sAltitudeTextField.text ?? "") ?? 0
        let activated = activateButton.isSelected
        print(activated)
        
        // Variable = Struct(Field: Variable)
        deadstick = DeadStick(aircraft: aircraft, gSpeed: gSpeed, gRatio: gRatio, sAltitude: sAltitude, activated: activated)
    }
    
    // End class definition.
}
