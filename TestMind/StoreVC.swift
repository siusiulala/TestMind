//
//  StoreVC.swift
//  TestMind
//
//  Created by kbala on 2017/8/2.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit

class StoreVC: UITableViewController {

    var storeName = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = storeName
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    @IBAction func beaconAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "beacon") as! BeaconVC
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
      
        self.present(myAlert, animated: true, completion: nil)
    }

    

}
