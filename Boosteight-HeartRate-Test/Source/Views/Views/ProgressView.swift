//
//  ProgressView.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 22.05.2024.
//

import UIKit

public final class ProgressView: UIView {
    
    public var progress: CGFloat = 0.0 {
        didSet {
            progress = min(progress, 1)
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                progressLayer.strokeEnd = progress
                progressLabel.text = "\(Int(progress * 100))%"
                if progress >= 1 {
                    onComplete()
                }
                layoutSubviews()
            }
        }
    }
    private var onComplete: () -> Void = {}
    
    //MARK: - Subviews
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .rubikRegular(ofSize: 14)
        label.textAlignment = .center
        label.text = "0%"
        return label
    }()
    
    //MARK: - Sublayers
    private var trackLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    
    //MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        progressLabel.frame = bounds
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        
        let lineWidth: CGFloat = frame.height - 2
        
        trackLayer.path = path.cgPath
        trackLayer.lineWidth = lineWidth
        
        progressLayer.path = path.cgPath
        progressLayer.lineWidth = lineWidth
        layer.cornerRadius = frame.height / 2
    }
    
    // MARK: - Methods
    private func setupView() {
        layer.borderColor = UIColor.brandOrange.cgColor
        layer.borderWidth = 1
        
        clipsToBounds = true
        
        trackLayer.fillColor = nil
        trackLayer.strokeColor = UIColor.disabledOrange.cgColor
        trackLayer.strokeEnd = 1
        layer.addSublayer(trackLayer)
        
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.brandOrange.cgColor
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
        
        addSubview(progressLabel)
    }
    
    
    
    //MARK: - Interfaces
    public func mockLoading(){
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self else { timer.invalidate(); return }
            if progress >= 1 { timer.invalidate(); return }
            progress += 0.01
        }
    }
    public func onComplete(completion: @escaping () -> Void) {
        onComplete = completion
    }
}
