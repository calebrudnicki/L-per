//
//  HomeViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/11/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//
//  Runner icon in top left created by Freepik at http://www.freepik.com
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var runButton: UIButton!
    
    
//MARK: Variables
    
    var locationManager = CLLocationManager()
    
    
//MARK: Boilerplate Functions
    
    //This function loads the view, calls the viewControllerLayoutChanges function, and sets up the location manager settings
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerLayoutChanges()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    //This function checkes the authorization status
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.checkLocationAuthorizationStatus()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Style Functions
    
    //This function sets the status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //This functions changes preset properties for the map and the button
    func viewControllerLayoutChanges() {
        mapView.tintColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
        runButton.layer.shadowColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0).CGColor
        runButton.layer.shadowOffset = CGSizeMake(5, 5)
        runButton.layer.shadowRadius = 5
        runButton.layer.shadowOpacity = 1.0
    }
    
    
//MARK: Actions
    
    //This function for the run button activates an alert controller that either segues into the RunTrackerViewController or returns back to the home screen
    @IBAction func runButtonTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Are you sure you're ready to start your run? If you proceed the timer will begin.", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes, I am ready", style: .Default) { (action) in
            self.performSegueWithIdentifier("startRunSegue", sender: self)
        }
        let noAction = UIAlertAction(title: "No wait, I need a minute", style: .Cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.view.tintColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //This function for the running man icon segues to the ListRunsTableViewController
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("seeListSegue", sender: self)
    }
    
    
//MARK: Location Functions
    
    //This functions checks to see the users authorization status and either allows the app to acces their location or sends an authorization request
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
    }
    
    
//MARK: Segues
    
    //This function recognizes the segue called in code based on the user's action and send the appropriate set of data along the segue too
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "seeListSegue" {
                let listRunsTableViewController = segue.destinationViewController as! ListRunsTableViewController
            } else if identifier == "startRunSegue" {
                let runTrackerViewController = segue.destinationViewController as! RunTrackerViewController
            }
        }
    }
    
    //This function can be connected to another view controller to unwind a segue
    @IBAction func unwindToHomeViewController(segue: UIStoryboardSegue) {
    }

}