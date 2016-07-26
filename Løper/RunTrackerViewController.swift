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
import CoreMotion
import HealthKit
import CoreData

class RunTrackerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIPopoverPresentationControllerDelegate {
    
//MARK: Outlets
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var stallTimeLabel: UILabel!
    @IBOutlet weak var stopRunButton: UIButton!
    
    
//MARK: Variables
    
    //Variables used to hold data for the labels and map drawings
    var distance: Double! = 0.0
    var runTime: Double! = 0.0
    var stallTime: Double! = 0.0
    var pace: Double! = 0.0
    var date = NSDate()
    var locations = [CLLocation]()
    lazy var timer = NSTimer()
    let lengthFormatter = NSLengthFormatter()
    lazy var userLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0.5
        locationManager.activityType = .Fitness
        return locationManager
    }()
    
    //Variables used to pass the data to the other view controllers
    var finalDistance: Double! = 0.0
    var finalTime: String! = "00:00:00"
    var finalPace: String! = "0:00 min / mi"
    var run: Run!
    var coords = [CLLocationCoordinate2D]()
    var motionManager: CMMotionManager!
    

//MARK: Boilerplate Functions
 
    //This function loads the view, calls the viewControllerLayoutChanges function, clears the array of locations, creates a timer, and creates a motion manager before calling the startLocationUpdates function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerLayoutChanges()
        self.mapView.delegate = self
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        startLocationUpdates()
    }

    //This function sets the showing of the user's location to true upon the view appearing
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        mapView.showsUserLocation = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

//MARK: Style Functions
    
    //This function changes the preset properties for the map and the navigation bar
    func viewControllerLayoutChanges() {
        mapView.tintColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.0)
        navigationBar.hidesBackButton = true
    }
    
    //This function allows the popover to take up only a portion of the view and not a whole page
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    
//MARK: Conversion Functions
    
    //This function converts distance and time values from meters and seconds to miles and minutes
    func convertUnits(distance: Double, time: Double) -> (distance: Double, time: String, pace: String) {
        let distance = distance * 0.000621371
        let distanceRounded = Double(round(100 * distance) / 100)
        let timeRounded = secondsToClockFormat(time)
        let pace = (time / 60) / distance
        let paceRounded = minutesToClockFormat(pace)
        return (distanceRounded, timeRounded, paceRounded)
    }
    
    //This function converts seconds into a hour:minute:second format
    func secondsToClockFormat(seconds: Double) -> String {
        let hourPlace = Int(floor(seconds * 3600) % 60)
        let minutePlace = Int(floor(seconds * 60) % 60)
        let secondPlace = Int(floor(seconds))
        return String(format: "%d:%02d:%02d", hourPlace, minutePlace, secondPlace)
    }
    
    //This function converts minutes into a minute:second format
    func minutesToClockFormat(minutes: Double) -> String {
        var minutePlace: Int! = 0
        var secondPlace: Int! = 0
        if minutes != Double.infinity {
            minutePlace = Int(floor(minutes))
            secondPlace = Int(floor(minutes * 60) % 60)
        }
        return String(format: "%02d:%02d", minutePlace, secondPlace)
    }
    
    
//MARK: Actions
    
    //This function that runs when the stop button is tapped stops locating the user, invalidates the timer, and calls the stopRunAlert function
    @IBAction func stopRunButtonTapped(sender: AnyObject) {
        userLocationManager.stopUpdatingLocation()
        timer.invalidate()
        stopRunAlert()
    }
    

//MARK: Alerts
    
    //This function either offers the user three options: to end and save, to end and not save, or to resume the run, it then shows a popup
    func stopRunAlert() {
        let alertController = UIAlertController(title: nil, message: "Are you are sure you're done with your run?", preferredStyle: .ActionSheet)
        let yesSaveAction = UIAlertAction(title: "Yes, I'm done", style: .Default) { (action) in
            self.saveRunToCoreData()
            self.callSavedPopup()
        }
        let yesCancelAction = UIAlertAction(title: "Yes, but don't save it", style: .Default) { (action) in
            self.callCancelPopup()
        }
        let noAction = UIAlertAction(title: "No", style: .Cancel) { (action) in
            self.viewDidLoad()
        }
        alertController.addAction(yesSaveAction)
        alertController.addAction(yesCancelAction)
        alertController.addAction(noAction)
        alertController.view.tintColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.0)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

//MARK: Popup Functions
    
    func callSavedPopup() {
        let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupViewController") as! PopupViewController
        self.addChildViewController(popupViewController)
        popupViewController.view.frame = self.view.frame
        self.view.addSubview(popupViewController.view)
        popupViewController.didMoveToParentViewController(self)
    }
    
    func callCancelPopup() {
        let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupViewController") as! PopupViewController
        self.addChildViewController(popupViewController)
        popupViewController.view.frame = self.view.frame
        self.view.addSubview(popupViewController.view)
        popupViewController.didMoveToParentViewController(self)
    }
    
    
//MARK: CoreData Functions
    
    //This function saves a run object (newRun) and a locations object (savedLocations) to Core Data
    func saveRunToCoreData() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let (d, t, p) = self.convertUnits(distance, time: runTime)
        finalDistance = d
        finalTime = t
        finalPace = p
        let newRun = NSEntityDescription.insertNewObjectForEntityForName("Run",inManagedObjectContext: managedObjectContext) as! Run
        newRun.pace = finalPace
        newRun.distance = finalDistance
        newRun.time = finalTime
        newRun.date = date
        var savedLocations = [Location]()
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location",inManagedObjectContext: managedObjectContext) as! Location
            savedLocation.latitude = location.coordinate.latitude
            savedLocation.longitude = location.coordinate.longitude
            savedLocations.append(savedLocation)
        }
        newRun.locations = NSOrderedSet(array: savedLocations)
        run = newRun
        do {
            try managedObjectContext.save()
        }
        catch let error as NSError {
            print("\(error) and info \(error.userInfo)")
        }
    }


//MARK: Location Functions
    
    //This function finds the user's location
    func startLocationUpdates() {
        userLocationManager.startUpdatingLocation()
    }
    
    //This function grabs the user's location, makes a 2D coordinate out of it, and then sets the view of the map onto that coordinate while it also updates the distance variable and then appends the current location to the array of locations as long as the acceleration of the phone is not 0
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let coord2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coord2D, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(coordinateRegion, animated: false)
        //print(locations[0].speed)
        for location in locations {
            if location.horizontalAccuracy < 30 {
                if self.locations.count > 0 {
                    distance = distance + location.distanceFromLocation(self.locations.last!)
                }
            }
            self.locations.append(location)
//            print(locations[0].speed)
//            if locations[0].speed > 0 {
//                print("Im here")
//                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondRunning(_:)), userInfo: nil, repeats: true)
//                
//            } else {
//                print("im here too")
//                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondStanding(_:)), userInfo: nil, repeats: true)
//            }
        }
    }
    

//MARK: Path Drawing
    
    //This function loops through the locations array and appends each location to an array of CLLocationCoordinate2D called coords
    func polyline() -> MKPolyline {
        coords = [CLLocationCoordinate2D]()
        let locations = self.locations
        for location in locations {
            coords.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                longitude:location.coordinate.longitude))
        }        
        return MKPolyline(coordinates: &coords, count: locations.count)
    }

    // This function draws the line for the path of the run
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKindOfClass(MKPolyline) {
            return MKPolylineRenderer()
        }
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline) 
        renderer.strokeColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.0)
        renderer.lineWidth = 10
        return renderer
    }


    
//MARK: Timer Functions
    
//    func eachSecond(timer: NSTimer, manager: CLLocationManager) {
//        if locations[0].speed > 0 {
//            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondRunning(_:)), userInfo: nil, repeats: true)
//        } else {
//            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondStanding(_:)), userInfo: nil, repeats: true)
//        }
//    }
    
    //This function calls for the line to be draw before it updates the time variable and updates all of the logos on the screen
    func eachSecond(timer: NSTimer) {
        mapView.addOverlay(polyline(), level: MKOverlayLevel.AboveLabels)
        runTime = runTime + 1
        let (d, t, p) = self.convertUnits(distance, time: runTime)
        let y = Double(round(100*d)/100)
        distanceLabel.text = "\(y) mi"
        runTimeLabel.text = t
        averagePaceLabel.text = "\(p) min/mi"
    }
    
    //This function
    func eachSecondStanding(timer: NSTimer) {
        stallTime = stallTime + 1
        let t = self.secondsToClockFormat(stallTime)
        stallTimeLabel.text = t
    }

}