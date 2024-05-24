//
//  ParentCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public class ParentCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    public var childCoordinators: [ChildCoordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        print("Did start Coordinator: \(String(describing: self))")
    }
    
}


