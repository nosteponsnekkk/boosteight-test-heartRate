//
//  MainCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class MainCoordinator: Coordinator {
    
    
    init(naviagtionController: UINavigationController) {
        self.naviagtionController = naviagtionController
    }
    
    public var naviagtionController: UINavigationController
    
    public func start() {
        let vc = SplashViewController()
        vc.coordinator = self
        naviagtionController.pushViewController(vc, animated: false)
    }
    
    
}
