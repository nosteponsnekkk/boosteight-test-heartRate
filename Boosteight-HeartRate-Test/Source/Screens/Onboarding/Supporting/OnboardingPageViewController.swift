//
//  OnboardingPageViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public enum OnboardingPage {
    case first
    case second
    case third
}

public final class OnboardingPageViewController: UIViewController {

    private let page: OnboardingPage
    
    //MARK: - Init
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        switch page {
        case .first:
            view.backgroundColor = .red
        case .second:
            view.backgroundColor = .green
        case .third:
            view.backgroundColor = .blue
        }
    }
    

}
