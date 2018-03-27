//
//  AltitudeViewController.swift
//  DeadStick
//
//  Created by Hal W. Dale, Jr. on 12/19/17.
//  Copyright © 2017 Hal W. Dale, Jr. All rights reserved.
//

import UIKit
import Foundation

class AltitudeViewController: UIViewController {
    
    var deadsticks = [DeadStick]()
    let emptyRecord = DeadStick(aircraft: "", gSpeed: 0, gRatio: 0.0, sAltitude: 0, activated: false)
    var activeRecord = false
    var aircraftName: String?
    let feetInMile: Double = 5280.0
    var distanceCalculation: Double = 0.0
    let altitudeInFeet: Double = 0.0
    var glideRatio: Double = 0.0
    
    @IBOutlet weak var headingTextField: UITextField!
    @IBOutlet weak var altitudeTextField: UITextField!
    
    @IBOutlet weak var aircraftLabel: UILabel!
    func addAircraftLabel() {
        aircraftLabel.text = aircraftName
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        headingTextField.resignFirstResponder()
    }
    
    @IBAction func Done(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    var activatedRecord = emptyRecord
        
    if let savedDeadSticks = DeadStick.loadDeadSticks() {
        deadsticks = savedDeadSticks
        let selection = deadsticks.filter {$0.activated == true}
        activatedRecord = selection.first ?? emptyRecord
        aircraftName = activatedRecord.aircraft
        glideRatio = activatedRecord.gRatio!
        activeRecord = activatedRecord.activated
        print(aircraftName!)
        print(glideRatio)
        print(activeRecord)
    }else {
    }
}
    
    // Calculate glide distance.
    @IBAction func calculateButton(_ sender: UIButton) {
        let altitudeInFeet = Double(altitudeTextField.text ?? "") ?? 0
        distanceCalculation = (altitudeInFeet * glideRatio) / feetInMile
        print(distanceCalculation)
    }
    
}




