//  
//  RunTrackerViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/12/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import HealthKit

class RunTrackerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    
    
//MARK: Variables
    
    var seconds: Double!
    var distance: Double!
    var pace: Double!
    lazy var userLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 10.0
        return locationManager
    }()
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    var run: Run!
    var runArray: [Run]!
    let lengthFormatter = NSLengthFormatter()
    

//MARK: viewDidLoad()
 
    //This function loads the view and then sets up map settings, clears the array of locations, and creates a timer before calling the startLocationUpdates function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        mapView.tintColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        startLocationUpdates()
        runArray = []
    }

    
//MARK: viewDidAppear()
    
    //This function sets the showing of the user's location to true upon the view appearing
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
    }

    
//MARK: didReceiveMemoryWarning()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

//MARK: Style Settings
    
    //This function sets the status bar to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
//MARK: Actions
    
    //This function
    @IBAction func stopRunButtonTapped(sender: AnyObject) {
        userLocationManager.stopUpdatingLocation()
        timer.invalidate()
        let run = Run(distance: distance, time: seconds, pace: pace, locations: locations)
        runArray.append(run)
        stopRunAlert()
    }
    

//MARK: Alerts
    
    //This function alerts the user to make sure he or she is done with his or her run
    func stopRunAlert() {
        let alertController = UIAlertController(title: nil, message: "Are you are sure you're done with your run?", preferredStyle: .ActionSheet)
        let yesAction = UIAlertAction(title: "Yes, I'm done", style: .Default) { (action) in
            self.performSegueWithIdentifier("exitSegue", sender: self)
        }
        let noAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        alertController.view.tintColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
//MARK: Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "exitSegue" {
                let homeViewController = segue.destinationViewController as! HomeViewController
                homeViewController.distance = distance
                homeViewController.time = seconds
            }
        }
    }


//MARK: Map / Location Functionalities
    
    //This function finds the user's location
    func startLocationUpdates() {
        userLocationManager.startUpdatingLocation()
    }
    
    //This function grabs the user's location, makes a 2D coordinate out of it, and then sets the view of the map onto that coordinate. Also, in the second half of the function, it updates the distance variable and then appends the current location to the array of locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let coord2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coord2D, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(coordinateRegion, animated: false)
        
        for location in locations {
            if location.horizontalAccuracy < 20 {
                if self.locations.count > 0 {
                    distance = distance + location.distanceFromLocation(self.locations.last!)
                    pace = distance / seconds
                }
                self.locations.append(location)
            }
        }
    }
    

//MARK: Path Drawing
    
    //This function loops through the locations array and appends each location to an array of CLLocationCoordinate2D called coords
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        let locations = self.locations
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude:location.coordinate.longitude))
        }
        return MKPolyline(coordinates: &coords, count: locations.count)
    }

    //This function draws the line of the path of the run
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKindOfClass(MKPolyline) {
            return MKPolylineRenderer()
        }
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor(red: 0.44, green: 0.62, blue: 0.80, alpha: 1.0)
        renderer.lineWidth = 3
        return renderer
    }

    
//MARK: Labels Updates
    
    //This functions adds to the seconds variable while it updates all of the labels on the screen
    func eachSecond(timer: NSTimer) {
        mapView.addOverlay(polyline())
        seconds = seconds + 1
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        let distanceMiles = distanceQuantity.doubleValueForUnit(HKUnit.mileUnit())
        let timeQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        let paceUnit = HKUnit.secondUnit().unitDividedByUnit(HKUnit.mileUnit())
        let paceQuantity = HKQuantity(unit: paceUnit, doubleValue: seconds / distanceMiles)
        let paceSecondsPerMile = (paceQuantity.doubleValueForUnit(paceUnit))
        let paceMinutesPerMile = paceSecondsPerMile / 60
        let distanceString = lengthFormatter.stringFromValue(distanceMiles, unit: .Mile)
        
        distanceLabel.text = "Distance: " + distanceString
        timeLabel.text = "Time: " + seconds.description + " secs"
        averagePaceLabel.text = "Pace: \(paceMinutesPerMile) minutes per mile"
    }

}