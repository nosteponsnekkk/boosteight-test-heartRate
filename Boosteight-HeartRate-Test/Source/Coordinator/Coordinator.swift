//
//  Coordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit
public protocol Coordinator: AnyObject {
    
    var naviagtionController: UINavigationController {
        get set
    }
    
    func start()
    
}
