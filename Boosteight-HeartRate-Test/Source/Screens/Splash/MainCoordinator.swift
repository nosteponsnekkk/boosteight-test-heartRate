//
//  MainCoordinator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class MainCoordinator: ParentCoordinator {
    
    private let didFinishOnboarding: Bool

    override init(navigationController: UINavigationController) {
        didFinishOnboarding = /*UserDefaults.standard.object(forKey: .didFinishOnboarding) as? Bool ??*/ false
        super.init(navigationController: navigationController)
    }
    
    public override func start() {
        super.start()
        let vc = SplashViewController()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
}

//MARK: - Interfaces
extension MainCoordinator {
    public func finishSplash(){
        if didFinishOnboarding {
            startHomeFlow()
        } else {
            startOnboardingFlow()
        }
    }
    public func startOnboardingFlow(){
        let child = OnboardingCoordinator(navigationController: navigationController)
        startChild(child)
    }
    public func startHomeFlow(){
        let child = HomeCoordinator(navigationController: navigationController)
        startChild(child)
    }

}
