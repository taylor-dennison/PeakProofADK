//
//  Peaks.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//

import Foundation
import CoreLocation
import SwiftUI

class Peaks: ObservableObject {
    
    @Published var highPeaks: [Peak] = []
    //optional for when there is no selected peak
    @Published var selectedHighPeak: Peak?
    
        init() {
            //load data from the plist
            if let path = Bundle.main.path(forResource: "highPeaks", ofType: "json") {
                
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let tempDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [String: Any]
                    
                    print(tempDict)
                    //dictionaries return optionals, so force unwrap, then force cast to Array of dictionaries
                    let tempArray = tempDict["highPeaks"]! as! Array<[String:Any]>
                    
                    var tempPeaks: [Peak] = []
                    
                    for dict in tempArray {
                        
                        let peakName = dict["name"]! as! String
                        let lat = Double(dict["lat"]! as! String)!
                        let long = -Double(dict["long"]! as! String)!
                        let elevation = dict["elevation"]! as! String
                        let difficulty = dict["difficulty"]! as! String
                        let ascentOfClimb = dict["ascentOfClimb"]! as! String
                        let roundTripDistance = dict["roundTripDistance"]! as! String
                        let averageDuration = dict["averageDuration"]! as! String
                        let image = dict["image"]! as! String
                        let patch = dict["patch"]! as! String
                        let peakDescription = dict["peakDescription"]! as! String
                        let location = CLLocation(latitude: lat, longitude: long)
                        
                        //create landmark and add to landmarks
                        let peak = Peak(peakName: peakName, elevation: elevation, difficulty: difficulty, ascentOfClimb: ascentOfClimb, roundTripDistance: roundTripDistance, averageDuration: averageDuration, patch: patch, peakDescription: peakDescription, image: image, lat: lat, long: long, location: location)
                        
                        tempPeaks.append(peak)
                        
                    }//for
                
                    highPeaks = tempPeaks.sorted(by: {$0.peakName < $1.peakName})
                    
                } catch {
                    print(error)
                }
            }//if let
            
          
        }//init
    

    
}//Parks
