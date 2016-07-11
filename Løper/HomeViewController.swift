//
//  HomeViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/11/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
//MARK: Variables
    
    var coreLocationManager = CLLocationManager()
    
    
//MARK: viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CLLocationManager.locationServicesEnabled() {
            coreLocationManager.startUpdatingLocation()
        }
    }
    
    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Actions
    
    @IBAction func runButtonTapped(sender: AnyObject) {
        print("run button selected")
    }
    
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        print("past runs button selected")
    }
}