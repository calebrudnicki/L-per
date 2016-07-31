//
//  HomeViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/11/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//
//  Runner icon in top left corner of HomeViewController was created by Freepik at http://www.freepik.com
//  Check mark icon in the PopupViewController was created Huu Nguyen at https://thenounproject.com/huu/
//  X mark icon in PopupViewController was created by Huu Nguyen at https://thenounproject.com/huu/
//

import UIKit
import MapKit
import WatchConnectivity

class HomeViewController: UIViewController, CLLocationManagerDelegate, WCSessionDelegate {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runButton: UIButton!
    
    
//MARK: Variables
    
    var locationManager = CLLocationManager()
    var randAltitude: Double!
    var randAngle: Double!
    
    
//MARK: Boilerplate Functions
    
    //This function creates a shared instance of PhoneSession, establishes the locationManager settings, and calls checkLocationAuthorizationStatus() and viewControllerLayoutChanges() before it starts updating location
    override func viewDidLoad() {
        super.viewDidLoad()
        PhoneSession.sharedInstance.startSession()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //This function establishes the class as an observer of the NSNotificationSender
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.recievedStartRunSegueNotifaction(_:)), name:"startRunToPhone", object: nil)
        randAltitude = Double(arc4random_uniform(350) + 50)
        randAngle = Double(arc4random_uniform(360))
        self.viewControllerLayoutChanges()
        self.checkLocationAuthorizationStatus()
    }
    
    //This function removes the observer from the NSNotication sender when the view disappears
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Style Functions
    
    //This function changes preset properties of the view controller
    func viewControllerLayoutChanges() {
        mapView.tintColor = UIColor.greenColor()
        let backgroundUserCoords = locationManager.location?.coordinate
        let backgroundUserPoint = CLLocationCoordinate2DMake((backgroundUserCoords?.latitude)!, (backgroundUserCoords?.longitude)!)
        mapView.region = MKCoordinateRegionMakeWithDistance(backgroundUserPoint, 1000,1000)
        mapView.mapType = MKMapType.SatelliteFlyover
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = backgroundUserPoint
        mapCamera.pitch = 45
        mapCamera.altitude = randAltitude
        mapCamera.heading = randAngle
        self.mapView.camera = mapCamera
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
    }
    
    
//MARK: Actions
    
    //This function for the run button calls startRunSegue()
    @IBAction func runButtonTapped(sender: AnyObject) {
        self.startRunSegue()
    }
    
    //This function for the running man icon segues to the ListRunsTableViewController
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        self.seeListSegue()
    }
    
    
//MARK: Segues
    
    //This functions is called when a startRunToPhone notification is posted and calls startRunSegue()
    func recievedStartRunSegueNotifaction(notification: NSNotification) {
        self.startRunSegue()
    }
    
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
                let listRunsTableViewController = segue.destinationViewController as! ListRunsTableViewController
            } else if identifier == "startRunSegue" {
                let runTrackerViewController = segue.destinationViewController as! RunTrackerViewController
            }
        }
    }
    
    //This function can be connected to by another view controller to unwind a segue
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    }

}