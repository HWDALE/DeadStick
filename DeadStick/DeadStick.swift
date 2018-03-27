//
//  DeadStick.swift
//  DeadStick
//
//  Created by Hal W. Dale, Jr. on 11/17/17.
//  Copyright © 2017 Hal W. Dale, Jr. All rights reserved.
//
import UIKit

// DeadStick array structure definition.
struct DeadStick: Codable {
    var aircraft: String!
    var gSpeed: Int?
    var gRatio: Double?
    var sAltitude: Int?
    var activated: Bool
    
    // Functions to load data.
    static func loadDeadSticks() -> [DeadStick]?  {
        guard let codedDeadSticks = try? Data(contentsOf: ArchiveURL)
            else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<DeadStick>.self,
                                               from: codedDeadSticks)
    }
    static func loadSampleDeadSticks() -> [DeadStick] {
        let deadstick1 = DeadStick(aircraft: "Cessna 172", gSpeed: 75,
                                   gRatio: 7, sAltitude: 2000, activated: false)
        let deadstick2 = DeadStick(aircraft: "Cessna 152", gSpeed: 70,
                                   gRatio: 8, sAltitude: 2000, activated: false)
        let deadstick3 = DeadStick(aircraft: "Aeronca Champ", gSpeed: 60,
                                   gRatio: 9, sAltitude: 2000, activated: false)
        
        return [deadstick1, deadstick2, deadstick3]
    }
    
    // Functions to set directory and save data.
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory,
                                 in: .userDomainMask).first!
    static let ArchiveURL =
        DocumentsDirectory.appendingPathComponent("deadsticks")
            .appendingPathExtension("plist")
    
    static func saveDeadSticks(_ deadsticks: [DeadStick]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedDeadSticks = try? propertyListEncoder.encode(deadsticks)
        try? codedDeadSticks?.write(to: ArchiveURL,
                               options: .noFileProtection)
    }
}
