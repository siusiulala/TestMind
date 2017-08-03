//
//  BeaconVC.swift
//  TestMind
//
//  Created by kbala on 2017/8/2.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import CoreLocation

class BeaconVC: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    
    @IBOutlet var msgBox: UILabel!
   
    
    var storeUUID = "B0702880-A295-A8AB-F734-031A98A512DE"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
    
        // 要求定位權限，這邊使用whenInUse會發生error
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self){
            if CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways{
                locationManager.requestAlwaysAuthorization()
            }
            
        }
    
        registerBeaconRegionWithUUID(uuidString: storeUUID,identifier: "macasbeacon",isMonitor: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: storeUUID)!, identifier: "macasbeacon")
        locationManager.stopMonitoring(for: region)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func registerBeaconRegionWithUUID(uuidString: String, identifier: String, isMonitor: Bool){
        
        let region = CLBeaconRegion(proximityUUID: UUID(uuidString: uuidString)!, identifier: identifier)
        region.notifyOnEntry = true //預設就是true
        region.notifyOnExit = true //預設就是true
        
        if isMonitor{
            locationManager.startMonitoring(for: region) //建立region後，開始monitor region
        }else{
            locationManager.stopMonitoring(for: region)
            locationManager.stopRangingBeacons(in: region)
//            beaconInformationLabel.text = "Beacon狀態"
//            stateLabel.text = "是否在region內?"
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        //To check whether the user is already inside the boundary of a region
        //delivers the results to the location manager’s delegate "didDetermineState"
        manager.requestState(for: region)
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        if state == CLRegionState.inside{
            if CLLocationManager.isRangingAvailable(){
                manager.startRangingBeacons(in: (region as! CLBeaconRegion))
//                stateLabel.text = "已在region中"
            }else{
                print("不支援ranging")
            }
        }else{
            manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
            view.backgroundColor = UIColor.white
        }
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        if CLLocationManager.isRangingAvailable(){
            manager.startRangingBeacons(in: (region as! CLBeaconRegion))
            
        }else{
            msgBox.text = "手機型號不支援本功能\n需要iPhone4s以上之機型\n請改以QRCode掃描"
            print("不支援ranging")
            sleep(3)
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }
    
    //The location manager calls this method whenever there is a boundary transition for a region.
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        manager.stopRangingBeacons(in: (region as! CLBeaconRegion))
//        view.backgroundColor = UIColor.white
//        stateLabel.text = "離開region"
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
    
        if (beacons.count > 0){
            if let nearstBeacon = beacons.first{
                
                var proximity = ""
                
                switch nearstBeacon.proximity {
                case CLProximity.immediate:
                    proximity = "Very close"
                    
                case CLProximity.near:
                    proximity = "Near"
                    
                case CLProximity.far:
                    proximity = "Far"
                    
                default:
                    proximity = "unknow"
                }
                
//                beaconInformationLabel.text = "Proximity: \(proximity)\n Accuracy: \(nearstBeacon.accuracy) meter \n RSSI: \(nearstBeacon.rssi)"
                print("beacon distance: \(nearstBeacon.accuracy) meter")
//                view.backgroundColor = UIColor.red
                msgBox.text = "恭喜\n獲得20點\n目前點數:12345"
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
        msgBox.text = "未知的錯誤"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print(error.localizedDescription)
        msgBox.text = "請開啟裝置的\n藍牙功能"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print(error.localizedDescription)
        msgBox.text = "請開啟裝置的\n藍牙功能"
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
