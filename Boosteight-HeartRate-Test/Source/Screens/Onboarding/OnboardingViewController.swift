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
        let view = PageIndicator(numberOfItems: viewModel.viewControllers.count)
        return view
    }()
    private lazy var button: RedLongButton = {
        return RedLongButton(title: "Почати!", action: didTapButton)
    }()
    
    //MARK: - Init
    public override init(transitionStyle style: UIPageViewController.TransitionStyle, 
                         navigationOrientation: UIPageViewController.NavigationOrientation,
                         options: [UIPageViewController.OptionsKey : Any]? = nil) {
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
                                      height: view.bounds.height/4)
        
        pageIndicator.frame = .init(x: bottomContainer.bounds.midX - 88/2,
                                    y: bottomContainer.bounds.midY - 14 - 14,
                                    width: 88,
                                    height: 14)
        
        button.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 44)
        button.center = CGPoint(x: bottomContainer.bounds.midX, y: bottomContainer.bounds.midY + 44 - 14)
    }
    
    //MARK: - Methods
    private func setupView(){
        dataSource = viewModel
        delegate = viewModel
        view.backgroundColor = .backgroundBlue
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(pageIndicator)
        bottomContainer.addSubview(button)
        if let viewController = viewModel.viewControllers.first as? OnboardingPageViewController {
            setViewControllers([viewController], direction: .forward, animated: true)
            viewController.performAnimation()
        }
        animateIn()
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
        guard index < viewModel.viewControllers.count else {
            animateOut { [weak self] in
                self?.coordinatror?.goHome()
            }
            
            return
        }
        guard let vc = viewModel.viewControllers[index] as? OnboardingPageViewController else { return }
        vc.prepareForAnimation()
        setViewControllers([vc], direction: .forward, animated: true)
        viewModel.pageIndex = index
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            vc.performAnimation()
        }
    }

    //MARK: - Animations
    private func animateIn(){
        button.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.button.alpha = 1
        }
    }
    private func animateOut(completion: @escaping () -> Void){
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.button.alpha = 0
            self?.pageIndicator.alpha = 0
            self?.viewControllers?.forEach({ $0.view.alpha = 0 })
        } completion: { _ in
            completion()
        }
    }
}
