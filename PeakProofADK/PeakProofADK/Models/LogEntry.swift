//
//  LogEntry.swift
//  PeakProofADK
//
//  Created by Taylor Dennison on 12/6/22.
//

import Foundation
import CoreData


//NSManaged annotation means that we are relying on CoreData for the properties.
class LogEntry: NSManagedObject {
    @NSManaged public var peakName: String
    @NSManaged public var weatherConditions: String
    @NSManaged public var date: String
    @NSManaged public var comments: String
    @NSManaged public var season: String
}
