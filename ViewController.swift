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
    
    @IBOutlet weak var stepsTakenLabel: UILabel!
    
    var healthManager: HealthManager = HealthManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        stepsTakenLabel.text = "\(healthManager.updateHealthData())"
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

