//
//  EventVC.swift
//  TestMind
//
//  Created by kbala on 2017/8/1.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit

class hCell : UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var triImg: UIImageView!
    @IBOutlet var eventImg: UIView!
}

class cCell : UICollectionViewCell {
    
    @IBOutlet var pointLabel: UILabel!
    @IBOutlet var storeLabel: UILabel!
    @IBOutlet var storeImg: UIView!
    @IBOutlet var distanceLabel: UILabel!
   
}

class EventVC: UITableViewController {

    @IBOutlet var contentCollectionView: UICollectionView!
    @IBOutlet var headerCollectionView: UICollectionView!
    let modeButton = UIButton(type: .system)
    var headerButton = ["限時活動", "族群挑戰", "全期活動", "長官驗收"]
    var storeButton = ["A店家", "B店家", "C店家","A店家", "B店家", "C店家","A店家", "B店家", "C店家","A店家", "B店家", "C店家"]
    var headerSelect: IndexPath = IndexPath(item: 0, section: 0)
    var oriFrame = CGRect()
    var lastScrollOffset: CGFloat = -9999999.0
    var currentStore = ""
    override func viewDidLoad() {
        
        super.viewDidLoad()
        oriFrame = self.tableView.frame
        
        
    }
    func mapMode() {
        print("mapMode")
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        modeButton.frame = CGRect(x: UIScreen.main.bounds.width/2-75, y: UIScreen.main.bounds.height-70, width: 150, height: 50)
        modeButton.layer.cornerRadius = 0.5 * modeButton.bounds.size.height
        modeButton.clipsToBounds = true
        modeButton.layer.backgroundColor = UIColor(red: 0, green: 148/255, blue: 212/255, alpha: 1.0).cgColor
        modeButton.setTitle("地圖模式", for: .normal)
        modeButton.setTitleColor(UIColor.white, for: .normal)
        modeButton.addTarget(self, action: #selector(mapMode), for: .touchUpInside)
        self.navigationController?.view.addSubview(modeButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {
        for view in (self.navigationController?.view.subviews)! {
            if view == modeButton{
                view.removeFromSuperview()
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentSize)
//        print(contentCollectionView.contentSize)
//        print(headerCollectionView.contentSize)
        
        if scrollView.contentSize == headerCollectionView.contentSize{
            UpdateHeaderSelected()
            return
        }
        
        if scrollView.contentSize == contentCollectionView.contentSize{
            var offset = scrollView.contentOffset.y
            if scrollView.contentOffset.y < 0 {
                offset = 0
            }
            if  scrollView.contentOffset.y > 70 {
                // 最多讓畫面上移70, 要記得事先將contentCollectionView的高度增加70, 下面才不會留空
                offset = 70
            }
            
            if offset == lastScrollOffset{
                return
            }
            else {
                print(offset)
                lastScrollOffset = offset
                self.tableView.frame = CGRect(x: oriFrame.origin.x, y: oriFrame.origin.y - offset, width: oriFrame.width, height: oriFrame.height + offset)
            }
        }
   
    }
    
    func UpdateHeaderSelected()
    {
        for cell in headerCollectionView.visibleCells as! [hCell]
        {
            if cell == headerCollectionView.cellForItem(at: headerSelect)
            {
                cell.triImg.isHidden = false
            }
            else{
                cell.triImg.isHidden = true
            }
        }
    }
 
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listToStore"
        {
            (segue.destination as! StoreVC).storeName = currentStore
        }
    }
    
    
}

extension EventVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == headerCollectionView {
            return headerButton.count
        } else {
            return storeButton.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == headerCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath as IndexPath) as! hCell
            cell.nameLabel.text = headerButton[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath as IndexPath) as! cCell
            cell.storeLabel.text = storeButton[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == headerCollectionView {
            headerSelect =  indexPath
            for cell in collectionView.visibleCells as! [hCell]
            {
                if cell == collectionView.cellForItem(at: indexPath)
                {
                    cell.triImg.isHidden = false
                }
                else{
                    cell.triImg.isHidden = true
                }
            }
            
//            for i in 0 ..< headerButton.count{
//                if let cell = collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? hCell{
//                if IndexPath(item: i, section: 0) == indexPath{
//                    cell.triImg.isHidden = false
//                }else{
//                    cell.triImg.isHidden = true
//
//                    }}
//            }
        } else {
            
            if let cell = collectionView.cellForItem(at: indexPath) as? cCell{
                currentStore = cell.storeLabel.text!
                performSegue(withIdentifier: "listToStore", sender: self)
            }
        }
        
    }
}

extension EventVC : UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == headerCollectionView {
            let itemsPerRow:CGFloat = 3
            let hardCodedPadding:CGFloat = 5
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight = collectionView.bounds.height
            return CGSize(width: itemWidth, height: itemHeight)
        }else{
            let itemsPerRow:CGFloat = 2
            let hardCodedPadding:CGFloat = 10
            let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
            let itemHeight = itemWidth
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }
}
