//
//  HomeViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public final class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?

    //MARK: - Subviews
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    
    
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
       
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomContainer.frame = .init(x: 0,
                                      y: view.bounds.maxY - view.bounds.height/4,
                                      width: view.bounds.width,
                                      height: view.bounds.height/4)
        
    }
    
    //MARK: - Methods
    private func setupView(){
        view.backgroundColor = .backgroundBlue
        view.addSubview(bottomContainer)
    }


}
