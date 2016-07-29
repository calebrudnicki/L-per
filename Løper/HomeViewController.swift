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
    var session: WCSession!
    
    
//MARK: Boilerplate Functions
    
    //This function sets up a session with WatchKit, establishes the locationManager settings, and calls the viewControllerLayoutChanges()
    override func viewDidLoad() {
        super.viewDidLoad()
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //This function checks the location authorization status
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        randAltitude = Double(arc4random_uniform(350) + 50)
        randAngle = Double(arc4random_uniform(360))
        self.viewControllerLayoutChanges()
        self.checkLocationAuthorizationStatus()
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
    
//MARK: Actions
    
    //This function for the run button segues to the RunTrackerViewController
    @IBAction func runButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("startRunSegue", sender: self)
    }
    
    //This function for the running man icon segues to the ListRunsTableViewController
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("seeListSegue", sender: self)
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
    
    
//MARK: Segues
    
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
    

//MARK: Watch Connectivity
    
    //This function runs a segue to the RunTrackerViewController on the main thread once the start run button is tapped on the watch
    ///////////
    func session(session: WCSession, didReceiveMessage gameStats: [String : AnyObject]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("startRunSegue", sender: self)
        }
    }
    ///////////

}