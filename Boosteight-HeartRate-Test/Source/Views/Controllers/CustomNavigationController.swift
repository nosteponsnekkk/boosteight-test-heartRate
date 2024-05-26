//
//  CustomNavigationController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 25.05.2024.
//

import UIKit

public final class CustomNavigationController: UINavigationController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationBar = self.navigationBar
        let appearance = UINavigationBarAppearance()
        appearance.setBackIndicatorImage(.back.resize(to: .init(width: 26, height: 24))
                                         , transitionMaskImage: .back.resize(to: .init(width: 26, height: 24)))
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .brandOrange
        appearance.shadowColor = .clear
        appearance.titlePositionAdjustment = .init(horizontal: -CGFloat.greatestFiniteMagnitude,
                                                   vertical: 0)
        appearance.titleTextAttributes = [
            .foregroundColor : UIColor.white,
            .font : UIFont.rubikRegular(ofSize: 20) as Any
            
        ]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = .white
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    public func animateIn(){
        navigationBar.transform = .identity.translatedBy(x: 0, y: -navigationBar.frame.height * 2)
        UIView.animate(withDuration: 0.5 , delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2) { [weak self] in
            self?.navigationBar.transform = .identity
        }
    }
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
