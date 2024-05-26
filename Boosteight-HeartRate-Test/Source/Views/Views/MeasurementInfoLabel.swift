//
//  MeasurementInfoLabel.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class MeasurementInfoLabel: UILabel {

    let type: MeasurmentSectionInfoType
    init(type: MeasurmentSectionInfoType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        switch type {
        case .slow:
            text = "<60 BPM"
        case .normal:
            text = "60-100 BPM"
        case .fast:
            text = ">100 BPM"
        }
        textColor = .black
        textAlignment = .right
        font = .rubikRegular(ofSize: 12)
    }

}
