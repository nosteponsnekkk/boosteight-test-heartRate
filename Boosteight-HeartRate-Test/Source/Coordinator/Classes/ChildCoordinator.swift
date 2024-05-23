//
//  ChildCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public class ChildCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    public weak var parent: ParentCoordinator?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        start()
    }
    deinit {
        print("Parent (\(String.init(describing: parent.self))) did finish child: \(String(describing: self))")
    }
    public func start() {
        print("Did start Coordinator: \(String(describing: self))")
    }
    
}
