//
//  ResultDetailViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class ResultDetailViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    
    private let model: HeartMeasurement
    
    //MARK: - Subviews
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    private lazy var button: RedLongButton = {
        return RedLongButton(title: "Готово", action: coordinator?.goHome)
    }()
    private lazy var cardView: MeasurmentCard = {
        let view = MeasurmentCard(model: model)
        return view
    }()
    
    
    //MARK: - Init
    init(model: HeartMeasurement) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        button.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 44)
        button.center = CGPoint(x: bottomContainer.bounds.midX, y: bottomContainer.bounds.midY + 44 - 14)
        cardView.frame = .init(x: view.bounds.midX - 355/2,
                               y: view.bounds.midY - 255/2 - 50,
                               width: 355,
                               height: 255)

    }
    //MARK: - Methods
    private func setupView(){
        title = "Результат"
        view.backgroundColor = .backgroundBlue
        navigationItem.setHidesBackButton(true, animated: true)
        let barButton = CustomBarButtonItem(type: .history, action: coordinator?.goHistory)
        barButton.setSize(.init(width: 120, height: 38))
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(button)
        view.addSubview(cardView)
        
    }
    
    
}
