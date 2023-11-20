//
//  Peak.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//

import Foundation
import CoreLocation
import MapKit

class Peak: NSObject, MKAnnotation, Identifiable  {
   
    //private class members
    var id: UUID = UUID()
    var peakName: String = ""
    private var elevation: String = ""
    private var difficulty: String = ""
    private var ascentOfClimb: String = ""
    private var roundTripDistance: String = ""
    private var averageDuration: String = ""
    private var patch: String = ""
    private var peakDescription: String = ""
    private var image: String = ""
    
    //CoreLocation variables
    private var location: CLLocation?
    private var lat: Double = 0
    private var long: Double = 0
 
    
    //needed for the MKAnnotation protocol
    var coordinate: CLLocationCoordinate2D {
        get {
            return location!.coordinate
        }
    }
    
    //optional - required with set callout true.
    var title : String? {
        get {
            return peakName
        }
    }
    
   var subtitle : String? {
        get {
            return "Elevation: \(elevation)"
        }
    }

    
    
    //class member Setters and Getters
    func getPeakName() -> String {
        peakName
    }
    func setPeakName(peakName: String) {
        let trimmedPeakName = peakName.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPeakName.count >= 3 && trimmedPeakName.count <= 75 {
            self.peakName = trimmedPeakName
        } else {
            self.peakName = "TBD"
            print("Bad value of \(trimmedPeakName) in set(peakName): setting to TBD")
        }
    }
   
    func getElevation() -> String {
        elevation
    }
    func setElevation(elevation: String) {
        self.elevation = elevation
    }
    func getDifficulty() -> String {
        difficulty
    }
    func setDifficulty(difficulty: String) {
        self.difficulty = difficulty
    }
    func getAscentOfClimb() -> String {
        ascentOfClimb
    }
    func setAscentOfClimb(ascentOfClimb: String) {
        self.ascentOfClimb = ascentOfClimb
    }
    func getRoundTripDistance() -> String {
        roundTripDistance
    }
    func setRoundTripDistance(roundTripDistance: String) {
        self.roundTripDistance = roundTripDistance
    }
    func getAverageDuration() -> String {
        averageDuration
    }
    func setAverageDuration(averageDuration: String) {
        self.averageDuration = averageDuration
    }
    func getPatch() -> String {
        patch
    }
    func setPatch(patch: String) {
        self.patch = patch
    }
    func getPeakDescription() -> String {
        peakDescription
    }
    func setPeakDescription(peakDescription: String) {
        self.peakDescription = peakDescription
    }
    func getImage() -> String {
        image
    }
    func setImage(image: String) {
        self.image = image
    }
    func getLocation() -> CLLocation? {
        location ?? nil
    }
    func setLocation(location: CLLocation?) {
        self.location = location
    }
    
    func getLong() -> Double {
        long
    }
    func setLong(long: Double) {
        self.long = long
    }
    func getLat() -> Double {
        lat
    }
    func setLat(lat: Double) {
        self.lat = lat
    }

    //Initializers
    init(peakName: String, elevation: String, difficulty: String, ascentOfClimb: String, roundTripDistance: String, averageDuration: String, patch: String, peakDescription: String, image: String, lat: Double, long: Double, location: CLLocation?) {
        super.init()
        self.setPeakName(peakName: peakName)
        self.setElevation(elevation: elevation)
        self.setDifficulty(difficulty: difficulty)
        self.setAscentOfClimb(ascentOfClimb: ascentOfClimb)
        self.setRoundTripDistance(roundTripDistance: roundTripDistance)
        self.setAverageDuration(averageDuration: averageDuration)
        self.setPatch(patch: patch)
        self.setPeakDescription(peakDescription: peakDescription)
        self.setImage(image: image)
        self.setLat(lat: lat)
        self.setLong(long: long)
        self.setLocation(location: location)
    }
    
    //convenience
    override convenience init() {
        self.init(peakName: "Unknown", elevation: "Unknown", difficulty: "Unknown", ascentOfClimb: "Unknown", roundTripDistance: "Unknown", averageDuration: "Unknown", patch: "marcyPatch", peakDescription: "Unknown", image: "Unknown", lat: 0.0, long: 0.0, location: nil)
    }
    
}// End of Class Park
