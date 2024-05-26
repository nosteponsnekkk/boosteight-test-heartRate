//
//  OnboardingViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit

public final class OnboardingViewController: UIViewController {

    weak var coordinatror: OnboardingCoordinator?
    private let viewModel = OnboardingViewModel()
    
    //MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        cv.backgroundColor = .backgroundBlue
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true
        return cv
    }()
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    private lazy var pageIndicator: PageIndicator = {
        let view = PageIndicator(numberOfPages: OnboardingPage.allCases.count)
        return view
    }()
    private lazy var button: RedLongButton = {
        return RedLongButton(title: "Почати!", action: didTapButton)
    }()
    
    
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
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
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
        collectionView.register(OnboardingPageCollectionViewCell.self)
        view.backgroundColor = .backgroundBlue
        view.addSubview(collectionView)
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(pageIndicator)
        bottomContainer.addSubview(button)
        
        animateIn()
    }
    private func bind(){
        viewModel.bind { [weak self] pageIndex in
            DispatchQueue.main.async {
                //Weird text change in figma
                if pageIndex != 1 {
                    self?.button.setTitle("Почати!", for: .normal)
                } else {
                    self?.button.setTitle("Продовжити", for: .normal)
                }
            }
        } offset: { [weak self] offset in
            self?.pageIndicator.offset = offset
        }
    }
    private func didTapButton(){
        let index = viewModel.pageIndex + 1
        let numberOfPages = OnboardingPage.allCases.count

        guard index < numberOfPages else {
            animateOut { [weak self] in
                self?.coordinatror?.goHome()
            }
            
            return
        }
                
        let pageSize = collectionView.bounds.width
        let offset = CGFloat(index) * pageSize
        
        collectionView.setContentOffset(.init(x: offset, y: collectionView.contentOffset.y), animated: true)

    }

    //MARK: - Animations
    private func animateIn(){
        button.alpha = 0
        pageIndicator.alpha = 0
        collectionView.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.button.alpha = 1
            self?.pageIndicator.alpha = 1
            self?.collectionView.alpha = 1
        }
    }
    private func animateOut(completion: @escaping () -> Void){
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.button.alpha = 0
            self?.pageIndicator.alpha = 0
            self?.collectionView.alpha = 0
        } completion: { _ in
            completion()
        }
    }
}
