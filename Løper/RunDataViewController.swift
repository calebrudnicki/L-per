//
//  RunDataViewController.swift
//  Løper
//
//  Created by Caleb Rudnicki on 7/18/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import MapKit

class RunDataViewController: UIViewController, MKMapViewDelegate {

//MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var runTimeLabel: UILabel!
    @IBOutlet weak var stallTimeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
//MARK: Variables
    
    var run: Run!
    var coordinates: [CLLocationCoordinate2D] = []
    var annotations: [MKPointAnnotation] = []
    var selectedRow: NSIndexPath!
   
    
//MARK: Boilerplate Functions
    
    //This function sets the map delegate
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function sets the labels of the view and calls loadMap()
    override func viewWillAppear(animated: Bool) {
        self.distanceLabel.text = String(run.distance!) + " mi"
        self.runTimeLabel.text = run.runTime
        self.stallTimeLabel.text = run.stallTime
        self.paceLabel.text = "\(run.pace!) min/mi"
        self.loadMap()
    }
    
    
//MARK: Map Functions
    
    //This function shows the map, calls addOverlay(), and calls mapRegion()
    func loadMap() {
        mapView.hidden = false
        mapView.addOverlay(polyline())
        mapView.region = mapRegion()
    }
    
    //This function sets the region that the map shows
    func mapRegion() -> MKCoordinateRegion {
        let initialLoc = run.locations!.firstObject as! Location
        var minLat = initialLoc.latitude!.doubleValue
        var minLng = initialLoc.longitude!.doubleValue
        var maxLat = minLat
        var maxLng = minLng
        let locations = run.locations!.array as! [Location]
        for location in locations {
            minLat = min(minLat, location.latitude!.doubleValue)
            minLng = min(minLng, location.longitude!.doubleValue)
            maxLat = max(maxLat, location.latitude!.doubleValue)
            maxLng = max(maxLng, location.longitude!.doubleValue)
        }
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2,
                longitude: (minLng + maxLng)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.1,
                longitudeDelta: (maxLng - minLng)*1.1))
    }
    
    
//MARK: Path Drawing
    
    //This function loops through the locations array and appends each location to an array of CLLocationCoordinate2D called coords while also checking for the first and last point location to call addPinToMap() on
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        let locations = run.locations
        var count = 0
        for location in locations! {
            if let location = location as? Location {
                if count == 0 {
                    self.addPinToMap(CLLocationCoordinate2D(latitude: location.latitude!.doubleValue,
                        longitude:location.longitude!.doubleValue), color: UIColor.greenColor())
                } else if count == (locations!.count - 1) {
                    self.addPinToMap(CLLocationCoordinate2D(latitude: location.latitude!.doubleValue,
                        longitude:location.longitude!.doubleValue), color: UIColor.redColor())
                }
                coords.append(CLLocationCoordinate2D(latitude: location.latitude!.doubleValue,
                longitude:location.longitude!.doubleValue))
            }
            count = count + 1
        }
        return MKPolyline(coordinates: &coords, count: locations!.count)
    }
    
    //This function adds a pin to the map
    func addPinToMap(coordinates: CLLocationCoordinate2D, color: UIColor) {
        let annotation = ColorPointAnnotation(pinColor: color)
        annotation.coordinate = coordinates
        self.mapView.addAnnotation(annotation)
    }
    

//MARK: MapView Delegate Functions
    
    //This function draws the line for the path of the run
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
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            pinView?.pinTintColor = colorPointAnnotation.pinColor
        }
        else {
            pinView?.annotation = annotation
        }
        return pinView
    }

}