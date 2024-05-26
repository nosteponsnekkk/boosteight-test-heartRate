//
//  MeasureButton.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class MeasureButton: UIButton {

    private let action: () -> Void
    
    init(action: @escaping () -> Void){
        self.action = action
        super.init(frame: .zero)
        setImage(.measureButton, for: .normal)
        addTarget(self, action: #selector(performAction), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func performAction(){
        let haptic = UIImpactFeedbackGenerator(style: .medium)
        haptic.prepare()
        haptic.impactOccurred()
        action()
    }

}
