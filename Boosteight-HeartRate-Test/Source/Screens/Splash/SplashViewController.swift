//
//  SplashViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class SplashViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Subviews
    private lazy var animatedHeart: AnimatedHeart = {
        let view = AnimatedHeart()
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Heart Rate"
        label.font = .rubikSemiBold(ofSize: 54)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    private lazy var progressView: ProgressView = {
        let view = ProgressView()
        
        return view
    }()
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        animateIn()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animatedHeart.frame = .init(x: view.bounds.midX - 266/2,
                                    y: view.bounds.height/6,
                                    width: 266,
                                    height: 240)
        
        titleLabel.frame = .init(x: 0,
                                 y: animatedHeart.frame.maxY + 20,
                                 width: view.bounds.width,
                                 height: 60)
        
        bottomContainer.frame = .init(x: 0,
                                      y: view.bounds.maxY - view.bounds.height/4,
                                      width: view.bounds.width,
                                      height: view.bounds.height/4)
        
        progressView.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 15)
        progressView.center = CGPoint(x: bottomContainer.bounds.midX, y: bottomContainer.bounds.midY)
    }
    
    //MARK: - Methods
    private func setupView(){
        view.backgroundColor = .backgroundBlue
        view.addSubview(animatedHeart)
        view.addSubview(titleLabel)
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(progressView)
        progressView
            .onComplete { [weak self] in
                self?.animateOut()
            }
        navigationItem.backButtonDisplayMode = .minimal

    }
    
    //MARK: - Animations
    private func animateIn(){
        titleLabel.alpha = 0
        titleLabel.transform = .identity.scaledBy(x: 0.8, y: 0.8)
        
        bottomContainer.alpha = 0
        bottomContainer.transform = .identity.translatedBy(x: 0, y: 100)
        
        progressView.alpha = 0
        
        UIView.animate(withDuration: 0.7, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.6) { [weak self] in
            self?.titleLabel.alpha = 1
            self?.titleLabel.transform = .identity
            
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3) { [weak self] in
            self?.bottomContainer.transform = .identity
            self?.bottomContainer.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.3) { [weak self] in
            self?.progressView.alpha = 1
        } completion: { [weak self] _ in
            self?.progressView.mockLoading()
            self?.animatedHeart.startPulse()
        }
    }
    private func animateOut(){
        animatedHeart.stopPulse()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5) { [weak self] in
                guard let self else { return }
                animatedHeart.transform = animatedHeart.transform.scaledBy(x: 0.9, y: 0.9)
                titleLabel.transform = animatedHeart.transform.scaledBy(x: 0.7, y: 0.7)
            }
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.animatedHeart.alpha = 0
                self?.titleLabel.alpha = 0
                self?.progressView.alpha = 0
            } completion: { [weak self] _ in
                self?.coordinator?.finishSplash()
            }
        }
    
}
