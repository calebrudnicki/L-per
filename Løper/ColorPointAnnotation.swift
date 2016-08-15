//
//  ColorPointAnnotation.swift
//  Løper
//
//  Created by Caleb Rudnicki on 8/13/16.
//  Copyright © 2016 Caleb Rudnicki. All rights reserved.
//

import UIKit
import MapKit

class ColorPointAnnotation: MKPointAnnotation {

//MARK: Variables
    
    var pinColor: UIColor
    
    
//MARK: Init Statements
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
    
}