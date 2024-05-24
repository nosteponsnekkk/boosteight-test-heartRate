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
    
    //MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikSemiBold(ofSize: 24)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikRegular(ofSize: 16)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    private var animatedImage: CombinedAnimatedImage?
    
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
        setupView()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = view.bounds.width - view.bounds.width/9.6
        titleLabel.frame.size = .init(width: width,
                                      height: 28)
        descriptionLabel.frame.size = .init(width: width,
                                            height: descriptionLabel.sizeThatFits(.init(width: width, height: .greatestFiniteMagnitude)).height)
        
        titleLabel.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY + 50)
        descriptionLabel.center = CGPoint(x: view.bounds.midX, y: titleLabel.frame.maxY + 16 + descriptionLabel.frame.size.height/2)
        
        animatedImage?.frame = .init(x: view.bounds.midX - 256/2,
                                     y: titleLabel.frame.minY - 258 - 20,
                                     width: 256,
                                     height: 258)
    }
    //MARK: - Methods
    private func setupView(){
        
        view.backgroundColor = .backgroundBlue
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        
        switch page {
        case .first:
            titleLabel.text = "Ваш трекер тиску"
            descriptionLabel.text = "Зазначайте, відстежуйте та аналізуйте свої\nпоказники артеріального тиску."
        case .second:
            titleLabel.text = "Персоналізовані поради"
            descriptionLabel.text = "Програма надає дієві поради, які\nдопоможуть вам підтримувати оптимальний\nрівень артеріального тиску та\nзменшити фактори ризику серцево-\nсудинних захворювань."
        case .third:
            titleLabel.text = "Нагадування"
            descriptionLabel.text = "Не відставайте від графіка контролю\nартеріального тиску та прийому ліків за\nдопомогою спеціальних нагадувань."
        }
        
        configureImage()
    }
    private func configureImage(){
        switch page {
        case .first:
            animatedImage = CombinedAnimatedImage(backgroundImage: .bgFirstPage, animatedImages: [
                .obj1FirstPage,
                .obj2FirstPage
            ])
        case .second:
            animatedImage = CombinedAnimatedImage(backgroundImage: .bgSecondPage, animatedImages: [
                .obj1SecondPage,
                .obj2SecondPage,
                .obj3SecondPage
            ])
        case .third:
            animatedImage = CombinedAnimatedImage(backgroundImage: .bgSecondPage, animatedImages: [
                .obj1ThirdPage,
                .obj2ThirdPage,
                .obj3ThirdPage
            ])
        }
        if let animatedImage {
            view.addSubview(animatedImage)
        }
    }
    
    //MARK: - Animations
    public func prepareForAnimation(){
        animatedImage?.prepareForAnimation()
    }
    public func performAnimation(){
        animatedImage?.animateIn()
    }
}
