//
//  HomeViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/11/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//
//  Reverse runner icon in top left created by Freepik at http://www.freepik.com
//

import UIKit
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    
//MARK: Variables
    
    var locationManager = CLLocationManager()
    
    
//MARK: viewDidLoad()
    
    //This function loads the view and sets up the location manager settings
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.tintColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
    }
    
    
//MARK: viewDidAppear()
    
    //This function disables the map features before checking for authorization status
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.zoomEnabled = false
        mapView.scrollEnabled = false
        mapView.rotateEnabled = false
        self.checkLocationAuthorizationStatus()
    }
    
    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
//MARK: Style Functions
    
    //This function sets the status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
//MARK: Actions
    
    //This function for the run button activates an alert controller that either segues into the next view controller or returns back to the home screen
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
    
    @IBAction func pastRunsButtonTapped(sender: AnyObject) {
        //To be edited at a later date
        print("Past runs button tapped")
    }
    
    
//MARK: Map Settings
    
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
    
    func unwindToHomeViewController(segue: UIStoryboardSegue) {
    }
    
    //This function recognizes the segue called in code based on the user's action and performs the correct segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "startRunSegue" {
                let runTrackerViewController = segue.destinationViewController as! RunTrackerViewController
            }
        }
    }
    
}