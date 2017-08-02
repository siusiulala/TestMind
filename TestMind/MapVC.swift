//
//  MapVC.swift
//  TestMind
//
//  Created by kbala on 2017/8/2.
//  Copyright © 2017年 kbala. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CustomPointAnnotation: MKPointAnnotation {
    var pinCustomImageName:String!
}

class MapVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapview: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentStore = ""
    let tmp1 =
        CLLocationCoordinate2D(latitude: 24.768719231411371, longitude: 121.02813385651801)
    let tmp2 =
        CLLocationCoordinate2D(latitude: 24.761719231411371, longitude: 121.02113385651801)
    let modeButton = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        
        
        // add Privace - location when in use
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //
        mapview.delegate = self
        mapview.showsUserLocation = true
        mapview.mapType = .standard
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = tmp1
//        mapview.addAnnotation(annotation)
        
        var pointAnnotation:CustomPointAnnotation!
        pointAnnotation = CustomPointAnnotation()
        pointAnnotation.pinCustomImageName = "pin_blue"
        pointAnnotation.coordinate = tmp1
        pointAnnotation.title = "A商店"
        pointAnnotation.subtitle = "0.1KM"
        var pointAnnotation2:CustomPointAnnotation!
        pointAnnotation2 = CustomPointAnnotation()
        pointAnnotation2.pinCustomImageName = "pin_orange"
        pointAnnotation2.coordinate = tmp2
        pointAnnotation2.title = "B商店"
        pointAnnotation2.subtitle = "0.3KM"
        var pinAnnotationView:MKPinAnnotationView!
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "mapPin")
        mapview.addAnnotation(pinAnnotationView.annotation!)
        mapview.addAnnotation(pointAnnotation2)
        mapview.selectAnnotation(pointAnnotation, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modeButton.frame = CGRect(x: UIScreen.main.bounds.width/2-75, y: UIScreen.main.bounds.height-70, width: 150, height: 50)
        modeButton.layer.cornerRadius = 0.5 * modeButton.bounds.size.height
        modeButton.clipsToBounds = true
        modeButton.layer.backgroundColor = UIColor(red: 0, green: 148/255, blue: 212/255, alpha: 1.0).cgColor
        modeButton.setTitle("列表模式", for: .normal)
        modeButton.setTitleColor(UIColor.white, for: .normal)
        modeButton.addTarget(self, action: #selector(listMode), for: .touchUpInside)
        self.navigationController?.view.addSubview(modeButton)
    }
    func listMode() {
        print("listMode")
        
        self.dismiss(animated: true, completion: nil)
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span = MKCoordinateSpanMake(0.005, 0.005)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: myLocation,span: span)
        self.mapview.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    let reuseIdentifier = "mapPin"
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        // Better to make this class property
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            let btn = UIButton(type: .detailDisclosure)
//            btn.frame = CGRect(x: 130, y: 0, width: 130, height: (annotationView?.frame.height)!)
//            btn.setImage(#imageLiteral(resourceName: "ad3"), for: .normal)
            btn.addTarget(self, action: #selector(callOutButtonPress), for: UIControlEvents.touchUpInside)
            annotationView?.rightCalloutAccessoryView = btn
        }
        
        let customPointAnnotation = annotation as! CustomPointAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.pinCustomImageName)
        annotationView?.canShowCallout = true
       
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        currentStore = ((view.annotation?.title)!
            )!
//        print(view.centerOffset)
    }
    
    func callOutButtonPress(_ sender : UIButton){
        performSegue(withIdentifier: "mapToStore", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToStore"
        {
            (segue.destination as! StoreVC).storeName = currentStore
        }
    }

}
