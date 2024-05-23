//
//  OnboardingCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public final class OnboardingCoordinator: ChildCoordinator {
    
    public override func start() {
        super.start()
        let vc = OnboardingViewController()
        vc.coordinatror = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    public func goHome(){
        UserDefaults.standard.setValue(true, forKey: .didFinishOnboarding)
        if let parent = parent as? MainCoordinator {
            parent.startHomeFlow()
            parent.childDidFinish(self)
        }
    }
}
