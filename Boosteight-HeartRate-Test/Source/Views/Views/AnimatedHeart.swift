//
//  AnimatedHeart.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class AnimatedHeart: UIView {

    //MARK: - Subviews
    private lazy var heartImageView: UIImageView = {
        let iv = UIImageView(image: .heart)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    private lazy var impulseImageView: UIImageView = {
        let iv = UIImageView(image: .impulse)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: - Init
    init(){
        super.init(frame: .zero)
        setupView()
        animateIn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        heartImageView.frame = bounds
        impulseImageView.frame = bounds
    }
    //MARK: - Methods
    private func setupView(){
        backgroundColor = .clear
        addSubview(heartImageView)
        addSubview(impulseImageView)
        heartImageView.layer.shadowColor = UIColor.black.cgColor
        heartImageView.layer.shadowOpacity = 0.4
        heartImageView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
    
    //MARK: - Animations
    private func animateIn(){
        heartImageView.alpha = 0
        impulseImageView.alpha = 0
        
        heartImageView.transform = .identity.scaledBy(x: 0.5, y: 0.5).translatedBy(x: 0, y: 500)
        impulseImageView.transform = .identity.rotated(by: 0.8)
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self else { return }
            heartImageView.alpha = 1
            heartImageView.layer.shadowRadius = 10
            impulseImageView.alpha = 1
        }
        UIView.animate(withDuration: 1.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2) { [weak self] in
            guard let self else { return }
            heartImageView.transform = .identity
            impulseImageView.transform = .identity
        }
   
        
    }
    
}
