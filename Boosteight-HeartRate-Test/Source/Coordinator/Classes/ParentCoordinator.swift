//
//  ParentCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public class ParentCoordinator: Coordinator {
    
    public var navigationController: UINavigationController
    var childCoordinators: [ChildCoordinator] = []

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        print("Did start Coordinator: \(String(describing: self))")
    }
    
}

extension ParentCoordinator {
    func startChild(_ child: ChildCoordinator) {
        childCoordinators.append(child)
        child.parent = self
    }
    
    func childDidFinish(_ child: ChildCoordinator?) {
        guard let child = child else { return }
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
