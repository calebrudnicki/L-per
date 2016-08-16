//
//  HomeViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/11/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//
//  Icon adapted from a design created by Parma at https://thenounproject.com/parma/
//  Check mark icon in the PopupViewController was created Huu Nguyen at https://thenounproject.com/huu/
//  X mark icon the PopupViewController was created by Huu Nguyen at https://thenounproject.com/huu/
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runButton: UIButton!
    
    
//MARK: Variables
    
    var locationManager = CLLocationManager()
    var randAltitude: Double!
    var randAngle: Double!
    
    
//MARK: Boilerplate Functions
    
    //This function establishes the locationManager settings and calls checkLocationAuthorizationStatus() and viewControllerLayoutChanges()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        self.checkLocationAuthorizationStatus()
        self.viewControllerLayoutChanges()
    }
    
    //This function generates two random integers each time the view appears
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        randAltitude = Double(arc4random_uniform(350) + 50)
        randAngle = Double(arc4random_uniform(360))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Style Functions
    
    //This function changes preset properties of the view controller
    func viewControllerLayoutChanges() {
        mapView.tintColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1)
    }
    
    
//MARK: Location Functions
    
    //This functions checks to see the users authorization status and either allows the app to access their location or sends an authorization request
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //This function grabs the user's location, makes a 2D coordinate out of it, and then sets the view of the map onto that coordinate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let coord2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coord2D, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(coordinateRegion, animated: false)
        mapView.mapType = MKMapType.SatelliteFlyover
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = coord2D
        mapCamera.pitch = 45
        mapCamera.altitude = randAltitude
        mapCamera.heading = randAngle
        self.mapView.camera = mapCamera
    }
    
    
//MARK: Actions
    
    //This function for the run button calls startRunSegue()
    @IBAction func runButtonTapped(sender: AnyObject) {
        self.startRunSegue()
    }
    
    //This function for the folder icon calls seeListSegue()
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        self.seeListSegue()
    }
    
    
//MARK: Segues
    
    //This function segues to the RunTrackerViewController
    func startRunSegue() {
        self.performSegueWithIdentifier("startRunSegue", sender: self)
    }
    
    //This functions segues to the ListRunsTableView
    func seeListSegue() {
        self.performSegueWithIdentifier("seeListSegue", sender: self)
    }
    
    //This function recognizes the segue called in code based on the user's action and segues to the appropriate view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "seeListSegue" {
                _ = segue.destinationViewController as! ListRunsTableViewController
            } else if identifier == "startRunSegue" {
                _ = segue.destinationViewController as! RunTrackerViewController
            }
        }
    }
    
    //This function can be connected to by another view controller to unwind a segue
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    }

}