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
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    
//MARK: Variables
    
    var run: Run!
    var coordinates: [CLLocationCoordinate2D] = []
    
    
//MARK: Boilerplate Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //This function sets the labels of the view
    override func viewWillAppear(animated: Bool) {
        self.distanceLabel.text = String(run.distance!) + " mi"
        self.timeLabel.text = run.time
        self.paceLabel.text = "\(run.pace!) min / mi"
        print(run.locations!.count)        
    }

}