//
//  ViewController.swift
//  Bluetooth Beacons
//
//  Created by Brendan Hodkinson on 10/09/2016.
//  Copyright © 2016 BatteryShed. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, ESTBeaconManagerDelegate{
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Range Region")
    
    @IBOutlet weak var ProtoLabel: UILabel!
    @IBOutlet weak var ProtoImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let content = ["Dog", "Cat", "Ratty"]
    
    override func viewDidLoad() {
        self.beaconManager.delegate = self
        
        self.beaconManager.requestWhenInUseAuthorization()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    override func viewDidDisappear(animated:Bool){
        super.viewDidDisappear(animated)
        self.beaconManager.stopMonitoringForRegion(beaconRegion)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier("InfoCell", forIndexPath: indexPath)
        
        cell.
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons{
            NSLog(beacon.description)
        }
    }

}