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
import CoreData
import AudioToolbox

class RunTrackerViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
//MARK: Outlets
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var stallTimeLabel: UILabel!
    @IBOutlet weak var stopRunButton: UIButton!
    
    
//MARK: Variables
    
    //Variables used to hold data for the labels and map drawings
    var distance: Double! = 0.0
    var time: Double! = 0.0
    var pace: Double! = 0.0
    var date = NSDate()
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    let lengthFormatter = NSLengthFormatter()
    lazy var userLocationManager: CLLocationManager = {
        var locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .Fitness
        locationManager.distanceFilter = 10.0
        return locationManager
    }()
    
    //Variables used to pass the data to the other view controllers
    var finalDistance: Double! = 0.0
    var finalTime: String! = "00:00:00"
    var finalPace: String! = "0:00 min / mi"
    var run: Run!
    

//MARK: Boilerplate Functions
 
    //This function loads the view, calls the viewControllerLayoutChanges function, clears the array of locations, and creates a timer before calling the startLocationUpdates function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllerLayoutChanges()
        self.mapView.delegate = self
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecond(_:)), userInfo: nil, repeats: true)
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
    
    
//MARK: Conversion Functions
    
    //This function converts distance and time values from meters and seconds to miles and minutes
    func convertUnits(distance: Double, time: Double) -> (distance: Double, time: String, pace: String) {
        let distance = distance * 0.000621371
        let distanceRounded = Double(round(100 * distance) / 100)
        let time = time / 60
        let timeRounded = secondsToClockFormat(time)
        let pace = time / distance
        let paceRounded = minutesToClockFormat(pace)
        return (distanceRounded, timeRounded, paceRounded)
    }
    
    //This function converts seconds into a hour:minute:second format
    func secondsToClockFormat(seconds: Double) -> String {
        let hourPlace = Int(floor(seconds * 3600) % 60)
        let minutePlace = Int(floor(seconds * 60) % 60)
        let secondPlace = Int(floor(seconds))
        return String(format: "%d:%02d:%02d", hourPlace, secondPlace, minutePlace)
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
    
    //This function either offers the user three options: to end and save, to end and not save, or to resume the run
    func stopRunAlert() {
        let alertController = UIAlertController(title: nil, message: "Are you are sure you're done with your run?", preferredStyle: .ActionSheet)
        let yesSaveAction = UIAlertAction(title: "Yes, I'm done", style: .Default) { (action) in
            self.saveRunToCoreData()
            self.performSegueWithIdentifier("exitSegue", sender: self)
        }
        let yesCancelAction = UIAlertAction(title: "Yes, but don't save it", style: .Default) { (action) in
            self.performSegueWithIdentifier("exitSegue", sender: self)
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
    
    
//MARK: Segues
    
    //This function allows the program to unwind segue to the HomeViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "exitSegue" {
                let homeViewController = segue.destinationViewController as! HomeViewController
            }
        }
    }
    
    
//MARK: CoreData Functions
    
    //This function saves a run object (newRun) and a locations object (savedLocations) to Core Data
    func saveRunToCoreData() {
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let (d, t, p) = self.convertUnits(distance, time: time)
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
    
    //This function grabs the user's location, makes a 2D coordinate out of it, and then sets the view of the map onto that coordinate while it also updates the distance variable and then appends the current location to the array of locations
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        let coord2D = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let coordinateRegion = MKCoordinateRegion(center: coord2D, span: MKCoordinateSpan(latitudeDelta: 0.003, longitudeDelta: 0.003))
        mapView.setRegion(coordinateRegion, animated: false)
        for location in locations {
            if location.horizontalAccuracy < 30 {
                if self.locations.count > 0 {
                    distance = distance + location.distanceFromLocation(self.locations.last!)
                }
            }
            self.locations.append(location)
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

    // This function draws the line for the path of the run
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        if !overlay.isKindOfClass(MKPolyline) {
            return MKPolylineRenderer()
        }
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline) 
        renderer.strokeColor = UIColor(red: 0.59, green: 0.59, blue: 0.59, alpha: 1.0)
        renderer.lineWidth = 3
        return renderer
    }

    
//MARK: Labels Updates
    
    //This functions calls for the line to be draw before it updates the time variable and updates all of the logos on the screen
    func eachSecond(timer: NSTimer) {
        mapView.addOverlay(polyline(), level: MKOverlayLevel.AboveLabels)
        time = time + 1
        let (d, t, p) = self.convertUnits(distance, time: time)
        let y = Double(round(100*d)/100)
        distanceLabel.text = "\(y) mi"
        timeLabel.text = "\(t)"
        averagePaceLabel.text = "\(p) min/mi"
    }

}