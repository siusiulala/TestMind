//
//  VocVC.swift
//  TestMind
//
//  Created by kbala on 2017/8/3.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit

class VocVC: UIViewController {

    let voc = VOC.initSDK(withSN: "a4e8c498a94b5d310cc5f4afa1ab4340")
    override func viewDidLoad() {
        super.viewDidLoad()

        voc?.clearData()
        voc?.setPropKey("sex", andValue: "1")
        
        voc?.updateData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
