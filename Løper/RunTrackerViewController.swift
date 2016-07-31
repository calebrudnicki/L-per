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
import LocationKit
import AudioToolbox

class RunTrackerViewController: UIViewController, MKMapViewDelegate, LKLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    
//MARK: Outlets
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var stallTimeLabel: UILabel!
    @IBOutlet weak var stopRunButton: UIButton!
    
    
//MARK: Variables
    
    //Variables for the functionality of the timers and the map accuracy
    var coords = [CLLocationCoordinate2D]()
//    lazy var timer = NSTimer()
    
    /////////
    lazy var runningTimer = NSTimer()
    lazy var standingTimer = NSTimer()
    /////////
    
    lazy var userLocationManager: LKLocationManager = {
        var locationManager =  LKLocationManager()
        locationManager.apiToken = "464a00f4c99abf3c"
        locationManager.debug = true
        locationManager.advancedDelegate = self
        let setting = LKSetting(type: .High)
        locationManager.setOperationMode(setting)
        return locationManager
    }()
    
    //Variables for labels and run info in the view
    var distance: Double! = 0.0
    var runTime: Double! = 0.0
    var pace: Double! = 0.0
    var stallTime: Double! = 0.0
    var locations: [CLLocation] = []
    var distanceDisplay: String! = "0.00"
    var runTimeDisplay: String! = "00:00:00"
    var paceDisplay: String! = "00:00 min/mi"
    var stallTimeDisplay: String! = "00:00:00"
    
    //Variables for data only being passed used in Core Data
    var run: Run!
    var finalDistance: String! = "0.00"
    var finalRunTime: String! = "00:00:00"
    var finalStallTime: String! = "00:00:00"
    var finalPace: String! = "0:00 min/mi"
    var date = NSDate()
    
    
//MARK: Boilerplate Functions
    
    //This function sets the map delegate, clears all the array of locations, starts a timer, and calls viewControllerLayoutChanges() and startLocationUpdates()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        locations.removeAll(keepCapacity: false)
        //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        self.viewControllerLayoutChanges()
        self.startLocationUpdates()
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
    
    //This function changes the preset properties of the view
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
    func convertUnitsRunning(distance: Double, time: Double) -> (distance: String, time: String, pace: String) {
        let distance = distance * 0.000621371
        let distanceRounded = String(Double(round(100 * distance) / 100))
        let timeRounded = secondsToClockFormat(time)
        let pace = (time / 60) / distance
        let paceRounded = minutesToClockFormat(pace)
        return (distanceRounded, timeRounded, paceRounded)
    }
    
    //This function converts seconds into an hour:minute:second format
    func secondsToClockFormat(seconds: Double) -> String {
        let hourPlace = Int(floor(seconds * 3600) % 60)
        let minutePlace = Int(floor(seconds / 60) % 60)
        let secondPlace = Int(floor(seconds) % 60)
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
    
    //This function that runs when the stop button is tapped stops locating the user, invalidates the timer, and calls stopRunAlert()
    @IBAction func stopRunButtonTapped(sender: AnyObject) {
        userLocationManager.stopUpdatingLocation()
        runningTimer.invalidate()
        standingTimer.invalidate()
        self.stopRunAlert()
    }
    
    
//MARK: Alerts
    
    //This function offers the user three options: to end and save, to end and not save, or to resume the run, before it either shows a popup or returns to the run
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
    
    //This function shows a popup confirming that the run has been saved
    func callSavedPopup() {
        let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupViewController") as! PopupViewController
        self.addChildViewController(popupViewController)
        popupViewController.view.frame = self.view.bounds
        popupViewController.userChoiceImage.image = UIImage(named: "CheckMark.png")
        popupViewController.userChoiceLabel.text = "Congrats! Your run was saved!"
        self.view.addSubview(popupViewController.view)
        popupViewController.didMoveToParentViewController(self)
    }
    
    //This function shows a popup confirming that the run was not saved
    func callCancelPopup() {
        let popupViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopupViewController") as! PopupViewController
        self.addChildViewController(popupViewController)
        popupViewController.view.frame = self.view.bounds
        popupViewController.userChoiceImage.image = UIImage(named: "XMark.png")
        popupViewController.userChoiceLabel.text = "Ok. Your run was not saved."
        self.view.addSubview(popupViewController.view)
        popupViewController.didMoveToParentViewController(self)
    }
    
    
//MARK: CoreData Functions
    
    //This function saves a run object (newRun) and a locations object (savedLocations) to Core Data
    func saveRunToCoreData() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let (d, t, p) = self.convertUnitsRunning(distance, time: runTime)
        finalDistance = d
        finalRunTime = t
        finalPace = p
        let newRun = NSEntityDescription.insertNewObjectForEntityForName("Run",inManagedObjectContext: managedObjectContext) as! Run
        newRun.pace = finalPace
        newRun.distance = finalDistance
        newRun.runTime = finalRunTime
        newRun.stallTime = finalStallTime
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
    
    //This function grabs the user's location, makes a 2D coordinate out of it, sets the view of the map onto that coordinate, and then it adds to the distance variable and appends each new location to the array of locations and calls pathCorrector()
    func locationManager(manager: LKLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let coord2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coord2D, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(coordinateRegion, animated: false)
        for location in locations {
            if location.horizontalAccuracy < 30 {
                if self.locations.count > 0 {
                    distance = distance + location.distanceFromLocation(self.locations.last!)
                }
                self.locations.append(location)
            }
        }
        self.pathCorrector()
    }

    //This function changes the tint of the map depending on whether the user is running or stationary
    func locationManager(manager: LKLocationManager, willChangeActivityMode mode: LKActivityMode) {
        if (mode == LKActivityMode.Stationary) {
            mapView.tintColor = UIColor.redColor()
            print("Standing")
            //runningTimer.invalidate()
            standingTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondStanding(_:)), userInfo: nil, repeats: true)
            print("Called the timer")
        } else {
            mapView.tintColor = UIColor.greenColor()
            print("Moving")
            //standingTimer.invalidate()
            runningTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecondRunning(_:)), userInfo: nil, repeats: true)
        }
    }
    
    
//MARK: Path Drawing
    
    //This function loops through the locations array and appends each location to an array of CLLocationCoordinate2D called coords
    func polyline() -> MKPolyline {
        coords = [CLLocationCoordinate2D]()
        for location in self.locations {
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
        renderer.lineWidth = 5
        return renderer
    }
    
    //This function smooths the path as the users moves by taking the average coordinate the point in front of and behind each point in the locations array
    func pathCorrector() {
        if self.locations.count > 2 {
            let currentLocation: CLLocation = self.locations[self.locations.count - 1]
            let middleLocation: CLLocation = self.locations[self.locations.count - 2]
            let oldLocation: CLLocation = self.locations[self.locations.count - 3]
            
            let currentCoords = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            var middleCoords = CLLocationCoordinate2D(latitude: middleLocation.coordinate.latitude, longitude: middleLocation.coordinate.longitude)
            let oldCoords = CLLocationCoordinate2D(latitude: oldLocation.coordinate.latitude, longitude: oldLocation.coordinate.longitude)
            
            let averageLatitude = (currentCoords.latitude + oldCoords.latitude) / 2
            let averageLongitude = (currentCoords.longitude + oldCoords.longitude) / 2
            
            middleCoords.latitude = averageLatitude
            middleCoords.longitude = averageLongitude
            
            let modifiedCoordinate = CLLocationCoordinate2D(latitude: middleCoords.latitude, longitude: middleCoords.longitude)
            let modifiedLocation = CLLocation(coordinate: modifiedCoordinate, altitude: middleLocation.altitude, horizontalAccuracy: middleLocation.horizontalAccuracy, verticalAccuracy: middleLocation.verticalAccuracy, course: middleLocation.course, speed: middleLocation.speed, timestamp: middleLocation.timestamp)
            
            self.locations[self.locations.count - 2] = modifiedLocation
        }
    }
    
    
//MARK: Timer Functions
    
    //This function calls for the line to be draw before it updates the time variable, sends data to the watch through a shared instance of PhoneSession, and updates all of the labels on the screen
//    func eachSecond(timer: NSTimer) {
//        mapView.addOverlay(polyline(), level: MKOverlayLevel.AboveLabels)
//        runTime = runTime + 1
//        let (d, t, p) = self.convertUnitsRunnig(distance, time: runTime)
//        PhoneSession.sharedInstance.giveWatchRunData(d, runTime: t, pace: p)
//        let y = Double(round(100*d)/100)
//        distanceLabel.text = "\(y) mi"
//        runTimeLabel.text = t
//        averagePaceLabel.text = "\(p) min/mi"
//    }
    
    
    func eachSecondRunning(timer: NSTimer) {
        runTime = runTime + 1
        mapView.addOverlay(polyline(), level: MKOverlayLevel.AboveRoads)
        (distanceDisplay!, runTimeDisplay!, paceDisplay!) = self.convertUnitsRunning(distance, time: runTime)
        PhoneSession.sharedInstance.giveWatchRunData(distanceDisplay, runTime: runTimeDisplay, pace: paceDisplay)
        //let rounded = Double(round(100*distanceDisplay)/100)
        distanceLabel.text = "\(distanceDisplay) mi"
        runTimeLabel.text = runTimeDisplay
        averagePaceLabel.text = "\(paceDisplay) min/mi"
        stallTimeLabel.text = stallTimeDisplay

        
    }
    
    func eachSecondStanding(timer: NSTimer) {
        print("Im running")
        stallTime = stallTime + 1
        stallTimeDisplay = secondsToClockFormat(stallTime)
        stallTimeLabel.text = stallTimeDisplay
    }
    
}