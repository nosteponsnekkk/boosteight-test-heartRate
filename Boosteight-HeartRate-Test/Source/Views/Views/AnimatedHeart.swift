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
    private lazy var measurementLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikSemiBold(ofSize: 62)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "--"
        label.alpha = 0
        return label
    }()
    private lazy var bpmLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikRegular(ofSize: 22)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "bpm"
        label.alpha = 0
        return label
    }()
    
    //MARK: - Sublayers
    private lazy var shadowLayer : CALayer = {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.red.cgColor
        shadowLayer.shadowOpacity = 0
        shadowLayer.shadowOffset = CGSize(width: 0, height: 10)
        shadowLayer.shadowRadius = 10
        return shadowLayer
    }()
    
    //MARK: - Init
    init(animateOnStart: Bool = true, frame: CGRect = .zero){
        super.init(frame: frame)
        setupView()
        if animateOnStart {
            animateIn()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        heartImageView.frame = bounds
        impulseImageView.frame = bounds
        
        measurementLabel.sizeToFit()
        measurementLabel.center = .init(x: heartImageView.bounds.midX,
                                        y: heartImageView.bounds.midY - 15)
        
        bpmLabel.sizeToFit()
        bpmLabel.center = .init(x: heartImageView.bounds.midX,
                                y: measurementLabel.frame.maxY + bpmLabel.frame.height + 5)
        let shadowPath = UIBezierPath(ovalIn: CGRect(x: bounds.minX + 20, y: bounds.maxY - 30, width: bounds.width - 40, height: 52))
        shadowLayer.shadowPath = shadowPath.cgPath

    }
    //MARK: - Methods
    private func setupView(){
        backgroundColor = .clear
        addSubview(heartImageView)
        addSubview(impulseImageView)
        layer.addSublayer(shadowLayer)

        heartImageView.layer.shadowColor = UIColor.black.cgColor
        heartImageView.layer.shadowOpacity = 0.4
        heartImageView.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        heartImageView.addSubview(measurementLabel)
        heartImageView.addSubview(bpmLabel)
        
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
    public func simpleAnimateIn(){
        heartImageView.alpha = 0
        impulseImageView.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            heartImageView.alpha = 1
            heartImageView.layer.shadowRadius = 10
            impulseImageView.alpha = 1
        }
    }
    public func prepareForMeasurment(){
        impulseImageView.alpha = 0
        measurementLabel.alpha = 1
        bpmLabel.alpha = 1
        
        heartImageView.layer.shadowOpacity = 0
        shadowLayer.shadowOpacity = 0.2
        
    }
    public func stopMeasurment(){
        impulseImageView.alpha = 1
        measurementLabel.alpha = 0
        bpmLabel.alpha = 0
        
        heartImageView.layer.shadowOpacity = 0.4
        shadowLayer.shadowOpacity = 0

    }
    
    public func setPulse(_ pulse: Float) {
        if pulse == .zero {
            measurementLabel.text = "--"
        } else {
            measurementLabel.text = "\(Int(pulse))"
        }
        layoutSubviews()
    }
}
