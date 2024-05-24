//
//  OnboardingViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public final class OnboardingViewController: UIPageViewController {

    weak var coordinatror: OnboardingCoordinator?
    private let viewModel = OnboardingViewModel()
    
    //MARK: - Subviews
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    private lazy var pageIndicator: PageIndicator = {
        let view = PageIndicator()
        return view
    }()
    private lazy var button: RedLongButton = {
        return RedLongButton(title: "Почати!", action: didTapButton)
    }()
    
    //MARK: - Init
    public override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bottomContainer.frame = .init(x: 0,
                                      y: view.bounds.maxY - view.bounds.height/4,
                                      width: view.bounds.width,
                                      height: view.bounds.height/3.5)
        button.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 44)
        button.center = CGPoint(x: bottomContainer.bounds.midX, y: bottomContainer.bounds.midY)
    }
    
    //MARK: - Methods
    private func setupView(){
        dataSource = viewModel
        delegate = viewModel
        view.backgroundColor = .backgroundBlue
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(button)
        if let viewController = viewModel.viewControllers.first {
            setViewControllers([viewController], direction: .forward, animated: true)
        }
    }
    private func bind(){
        viewModel.bind { [weak self] pageIndex in
            DispatchQueue.main.async {
                self?.pageIndicator.pageIndex = pageIndex
                //Weird text change in figma
                if pageIndex != 1 {
                    self?.button.setTitle("Почати!", for: .normal)
                } else {
                    self?.button.setTitle("Продовжити", for: .normal)
                }
            }
        }
    }
    
    private func didTapButton(){
        let index = viewModel.pageIndex + 1
        guard index < viewModel.viewControllers.count else { return }
        setViewControllers([viewModel.viewControllers[index]], direction: .forward, animated: true)
        viewModel.pageIndex = index
        
        
    }

}
