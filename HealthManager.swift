//
//  HealthManager.swift
//  Pedometer
//
//  Created by Hamilton Dang on 11/9/15.
//  Copyright © 2015 Codon. All rights reserved.
//

import Foundation
import UIKit
import HealthKit


class HealthManager {
    
    let healthStore: HKHealthStore = HKHealthStore()
    //needs an init method that asks for authorization
    
    init(){
        requestAuthorization({ (success, error) -> Void in
            if success{
                print("Health data authorized")
            }
            else {
                print("Health data not authorized")
            }
        })
    }
    
    func requestAuthorization(completion: ((success:Bool, error:NSError!) -> Void)!){
        let stepsCount = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        //describe the data types that you want to access
        let dataTypesToShare = NSSet(object: stepsCount!)
        let dataTypesToRead = NSSet(object: stepsCount!)
        
        //Check if health data is avilable
        if !HKHealthStore.isHealthDataAvailable() {
            let error = NSError(domain: "com.Codon.Pedometer", code: 2, userInfo: [NSLocalizedDescriptionKey: "HealthKit is not avilable on this device"])
            if (completion != nil){
                completion(success: false, error: error)
            }
        }
        //request authorization
        healthStore.requestAuthorizationToShareTypes(dataTypesToShare as? Set<HKSampleType>, readTypes: dataTypesToRead as? Set<HKObjectType>) {
            (success, error) -> Void in
            if (completion != nil) {
                completion(success: success, error: error)
            }
        }
    }
    
    func backgroundQuery(sampleType:HKSampleType , completion: ((HKSample!, NSError!) -> Void)!){
        
        //build query type
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: nil, limit: 100, sortDescriptors: nil) {
            (sampleQuery, results, error) -> Void in
            if (error != nil) {
                completion(nil, error)
            }
            //enable background query for continuous update
            self.healthStore.enableBackgroundDeliveryForType(sampleType, frequency: HKUpdateFrequency.Immediate, withCompletion:
                { (succeeded, error) -> Void in
                    if succeeded{
                        print("Background delivery enabled")
                    } else {
                        print("Background delivery denied")
                    }
            })
        }
        //excute query
        healthStore.executeQuery(sampleQuery)
    }

}

