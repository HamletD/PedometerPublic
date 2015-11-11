//
//  ViewController.swift
//  Pedometer
//
//  Created by Hamilton Dang on 11/9/15.
//  Copyright © 2015 Codon. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingWheel: UIActivityIndicatorView!
    @IBOutlet weak var stepsTakenLabel: UILabel!
    
    var healthManager: HealthManager = HealthManager()
    var localizedStepDouble: Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateHealthData()
    }

    func updateHealthData(){
        stepsTakenLabel.text = "Loading"
        loadingWheel.hidden = false
   
        let sampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        var stepSample: HKQuantitySample?
        
        //excute query
        healthManager.backgroundQuery(sampleType!) { (mostRecentSample, error) -> Void in
            if(error != nil){
                print("Error in background query")
            }
            
            stepSample = mostRecentSample as? HKQuantitySample
            self.localizedStepDouble = (stepSample?.quantity.doubleValueForUnit(HKUnit.countUnit()))!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.reloadUI()
            })
        }
    }
    func reloadUI(){
        self.stepsTakenLabel.text = "\(self.localizedStepDouble)"
        loadingWheel.hidden = true
    }
}

