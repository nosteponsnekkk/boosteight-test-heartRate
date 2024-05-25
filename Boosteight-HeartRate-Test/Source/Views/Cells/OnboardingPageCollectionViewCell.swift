//
//  OnboardingPageViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public enum OnboardingPage: CaseIterable {
    case first
    case second
    case third
}

public final class OnboardingPageCollectionViewCell: UICollectionViewCell {
    
    private var page: OnboardingPage = .first
    
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
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width - bounds.width/9.6
        titleLabel.frame.size = .init(width: width,
                                      height: 28)
        descriptionLabel.frame.size = .init(width: width,
                                            height: descriptionLabel.sizeThatFits(.init(width: width, height: .greatestFiniteMagnitude)).height)
        
        titleLabel.center = CGPoint(x: bounds.midX, y: bounds.midY + 50)
        descriptionLabel.center = CGPoint(x: bounds.midX, y: titleLabel.frame.maxY + 16 + descriptionLabel.frame.size.height/2)
        
        animatedImage?.frame = .init(x: bounds.midX - 256/2,
                                     y: titleLabel.frame.minY - 258 - 20,
                                     width: 256,
                                     height: 258)
    }

    //MARK: - Methods
    private func setupView(){
        
        backgroundColor = .backgroundBlue
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        
        
    }
    private func configureImage(){
        if let animatedImage {
            animatedImage.removeFromSuperview()
        }
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
            addSubview(animatedImage)
        }
    }
    
 
    //MARK: - Interfaces
    public func setPage(page: OnboardingPage) {
        self.page = page
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
    public func performAnimation(){
        animatedImage?.animateIn()
    }
}
