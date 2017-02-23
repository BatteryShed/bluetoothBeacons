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
    let beaconRegion = CLBeaconRegion(proximityUUID: UUID(uuidString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!, identifier: "Range Region")
    let database = DatabaseManager()

    @IBOutlet weak var tableView: UITableView!
    
    var content:[Item] = []
    
    override func viewDidLoad() {
        self.beaconManager.delegate = self
        
        self.beaconManager.requestWhenInUseAuthorization()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.beaconManager.startRangingBeacons(in: beaconRegion)
    }
    
    override func viewDidDisappear(_ animated:Bool){
        super.viewDidDisappear(animated)
        self.beaconManager.stopMonitoring(for: beaconRegion)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! ContentCell
        
        cell.ProtoLabel?.text = content[indexPath.row].title
        cell.ProtoImage.image = UIImage(named: content[indexPath.row].image_name)
        
        return cell
    }
    
    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        content = database.getVisibleBeacons(beaconsInRange: beacons)
    }

}
