//
//  MeasurementContainer.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public enum MeasurmentState {
    case initial
    case inProgress
}

public final class MeasurementContainer: UIView {
    
    public var state: MeasurmentState = .initial {
        didSet {
            switch state {
            case .initial:
                titleLabel.text = "Палець не виявлено"
                descriptionLabel.text = "Щільно прикладіть палець до камери"
            case .inProgress:
                titleLabel.text = "Йде Вимірювання."
                descriptionLabel.text = "Визначаємо ваш пульс. Утримуйте!"
            }
        }
    }

    private lazy var cameraView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = #colorLiteral(red: 0.2960370183, green: 0.7229825854, blue: 1, alpha: 1)
        view.backgroundColor = .clear
        view.isOpaque = true
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = .black
        return view
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Палець не виявлено"
        label.textColor = .black
        label.font = .rubikSemiBold(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Щільно прикладіть палець до камери"
        label.textColor = .white
        label.font = .rubikRegular(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    init(){
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        cameraView.frame = .init(x: bounds.midX - 42/2,
                                 y: 10,
                                 width: 42,
                                 height: 42)
        
        titleLabel.frame = .init(x: 0, y: cameraView.frame.maxY + 10, width: bounds.width, height: 22)
        descriptionLabel.frame = .init(x: 0, y: titleLabel.frame.maxY + 5, width: bounds.width, height: 22)

        cameraView.layer.cornerRadius = 42/2
    }
    
    private func setupView(){
        addSubview(cameraView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    public var previewLayer: CALayer {
        cameraView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        return cameraView.layer
    }
}
