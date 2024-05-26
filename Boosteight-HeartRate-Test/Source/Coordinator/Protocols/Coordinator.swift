//
//  Coordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit
public protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    var childCoordinators: [ChildCoordinator] { get set }

    func start()
    
}
extension Coordinator {
    func startChild(_ child: ChildCoordinator) {
        childCoordinators.append(child)
        child.parent = self
        navigationController.viewControllers.removeAll()
        child.start()
    }
    
    func childDidFinish(_ child: ChildCoordinator?) {
        guard let child = child else { return }
        for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
            childCoordinators.remove(at: index)
            break
        }
    }
}
