//
//  HelperBarButton.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public enum BarButtonConfiguration: String {
    case history = "Історія"
}

public final class HelperBarButton: UIButton {
    
    private let action: () -> Void
    private let type: BarButtonConfiguration

    init(type: BarButtonConfiguration, action: @escaping () -> Void){
        self.action = action
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        switch type {
        case .history:
            setImage(.history, for: .normal)
        }
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
        setTitle(type.rawValue, for: .normal)
        titleLabel?.textColor = .white
        tintColor = .white
        titleLabel?.textAlignment = .left
        titleLabel?.font = .rubikRegular(ofSize: 20)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = .init(x: bounds.maxX - 38,
                                 y: bounds.midY - 38/2,
                                 width: 38,
                                 height: 38)

        titleLabel?.frame = .init(x: (imageView?.frame.minX ?? 0) - 68 - 10 ,
                                  y: 0,
                                  width: 68,
                                  height: bounds.height)
    }
    
    @objc private func performAction() {
        action()
    }
}
