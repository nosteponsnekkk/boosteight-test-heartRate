//
//  CombinedAnimatedImage.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public final class CombinedAnimatedImage: UIView {

    private let backgroundImage: UIImage
    private let animatedImages: [UIImage]
    private var imageViews: [UIImageView] = []
    
    //MARK: - Subviews
    private lazy var backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Init
    init(backgroundImage: UIImage, animatedImages: [UIImage]) {
        self.backgroundImage = backgroundImage
        self.animatedImages = animatedImages
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.frame = bounds
        imageViews.forEach { [weak self] in
            guard let self else { return }
            $0.frame = bounds
        }
    }
 
    //MARK: - Methods
    private func setupView(){
        addSubview(backgroundImageView)
        
        animatedImages.forEach { [weak self] in
            guard let self else { return }
            let imageView = UIImageView(image: $0)
            imageView.contentMode = .scaleAspectFit
            imageView.alpha = 0
            addSubview(imageView)
            imageViews.append(imageView)
        }
    }
    
    //MARK: - Animations
    public func prepareForAnimation(){
        imageViews.forEach { $0.alpha = 0 }
    }
    public func animateIn(){
        for (index, imageView) in imageViews.enumerated() {
            imageView.alpha = 0
            imageView.transform = .identity.scaledBy(x: 0.8, y: 0.8).translatedBy(x: 0, y: index != 0 ? 200 : -200)
            UIView.animate(withDuration: 0.5, delay: 0.25 * Double(index), usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2) {
                imageView.alpha = 1
                imageView.transform = .identity
            }
        }
    }

}
