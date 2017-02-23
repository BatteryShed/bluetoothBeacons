//
// Created by Brendan Hodkinson on 11/12/16.
// Copyright (c) 2016 BatteryShed. All rights reserved.
//

import Foundation
import SQLite

struct Item{
    var title:String
    var description: String
    var image_name:String

    init(title:String, description: String, image_name: String){
        self.title = title
        self.description = description
        self.image_name = image_name
    }
}

class DatabaseManager {
    let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
    ).first!
    let db:Connection

    let beacons = Table("beacons")
    let id = Expression<Int64>("id")
    let uuid = Expression<String?>("beacon_uuid")
    let major = Expression<Int64>("major")
    let minor = Expression<Int64>("minor")
    let image_name = Expression<String?>("image_name")
    let title = Expression<String?>("title")
    let description = Expression<String?>("description")

    init(){
        let userDefaults = UserDefaults.standard
        db = try! Connection("\(path)/db.sqlite3")

        if(!userDefaults.bool(forKey: "hasBeenLaunched")) {
            userDefaults.set(true, forKey: "hasBeenLaunched")

            try! self.db.run(beacons.create { t in
                t.column(id, primaryKey: true)
                t.column(uuid)
                t.column(major)
                t.column(minor)
                t.column(image_name, unique: true)
                t.column(title)
                t.column(description)
            })
            let insertBeaconOne = beacons.insert(uuid <- "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major <- 29518, minor <- 44336, image_name <- "tasdevil", title <- "Title", description <- "Description text here")
            let insertBeaconTwo = beacons.insert(uuid <- "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major <- 36420, minor <- 34969, image_name <- "tasdevil", title <- "Title", description <- "Description text here")
            let insertBeaconThree = beacons.insert(uuid <- "B9407F30-F5F8-466E-AFF9-25556B57FE6D", major <- 58194, minor <- 35646, image_name <- "tasdevil", title <- "Title", description <- "Description text here")
            try! db.run(insertBeaconOne)
            try! db.run(insertBeaconTwo)
            try! db.run(insertBeaconThree)
        }
    }

    func getVisibleBeacons(beaconsInRange: [CLBeacon]) -> [Item] {
        var itemsInRange:[Item] = []
        for beacon in beaconsInRange{
            let itemQuery = beacons.filter(major == Int64(beacon.major) && minor == Int64(beacon.minor))
            for entry in try! db.prepare(itemQuery){
                let item = Item(title: entry[title]!, description: entry[description]!, image_name: entry[image_name]!)
                itemsInRange.append(item)
            }

        }
        
        return itemsInRange
    }
}
