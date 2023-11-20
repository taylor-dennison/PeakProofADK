//
//  Badge.swift
//  PeakProofADK
//
//  Created by Taylor Dennison on 12/5/22.
//

import Foundation
import CoreData


//NSManaged annotation means that we are relying on CoreData for the properties.
class Badge: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var earned: Bool
}

