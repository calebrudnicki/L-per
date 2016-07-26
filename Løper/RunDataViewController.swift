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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
//MARK: Variables
    
    var run: Run!
    var coordinates: [CLLocationCoordinate2D] = []
    var annotations: [MKPointAnnotation] = []
   
    
//MARK: Boilerplate Functions
    
    //This function sets the map's delegate to self
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function sets the labels of the view and then loads the map
    override func viewWillAppear(animated: Bool) {
        self.distanceLabel.text = String(run.distance!) + " mi"
        self.timeLabel.text = run.time
        self.paceLabel.text = "\(run.pace!) min/mi"
        loadMap()
    }

    
//MARK: Map Functions
    
    //This functions either hides the map if there are no location points or shows the map and calls the addOverlay function
    func loadMap() {
        if run.locations!.count < 0 {
            mapView.hidden = true
        } else {
            mapView.hidden = false
            mapView.addOverlay(polyline())
            mapView.region = mapRegion()
//            setupAnnotations()
//            addAnnotations()
            
        }
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
    
//    func setupAnnotations() {
//        var annotation: MKPointAnnotation
//        for location in run!.locations!.array as! [Location] {
//            annotation = MKPointAnnotation()
//            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude!.doubleValue,
//                                                           longitude:location.longitude!.doubleValue)
//            annotations.append(annotation)
//        }
//        
//    }
//    func addAnnotations() {
//        self.mapView.addAnnotations(annotations)
//        
//    }
    
    //This function loops through the locations array and appends each location to an array of CLLocationCoordinate2D called coords
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        let locations = run.locations
        for location in locations! {
            if let location = location as? Location {
                coords.append(CLLocationCoordinate2D(latitude: location.latitude!.doubleValue,
                longitude:location.longitude!.doubleValue))
            }
        }
        return MKPolyline(coordinates: &coords, count: locations!.count)
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

}