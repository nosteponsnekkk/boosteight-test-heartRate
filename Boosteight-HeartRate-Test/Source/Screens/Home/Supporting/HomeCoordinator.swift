//
//  HomeCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public final class HomeCoordinator: ChildCoordinator {
    
    public override func start() {
        super.start()
        let vc = HomeViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    
    
}
extension HomeCoordinator {
    func openDetail(for model: HeartMeasurement) {
        let vc = ResultDetailViewController(model: model)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    func goHome(){
        navigationController.popToViewController(ofClass: HomeViewController.self)
    }
    func goHistory(){
        let vc = HistoryViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
