//
//  MeasurmentSectionInfo.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public enum MeasurmentSectionInfoType {
    case slow
    case normal
    case fast
}

public final class MeasurmentSectionInfo: UIView {

    let type: MeasurmentSectionInfoType
    
    private lazy var indicator: UIView = {
        let view = UIView()
        switch type {
        case .slow:
            view.backgroundColor = .slow
        case .normal:
            view.backgroundColor = .normal
        case .fast:
            view.backgroundColor = .fast
        }
        return view
    }()
    private lazy var label: UILabel = {
        let label = UILabel()
        switch type {
        case .slow:
            label.text = "Уповільнений"
        case .normal:
            label.text = "Звичайний"
        case .fast:
            label.text = "Прискорений"
        }
        label.textColor = .black
        label.font = .rubikRegular(ofSize: 12)
        return label
    }()
    
    init(type: MeasurmentSectionInfoType) {
        self.type = type
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        indicator.frame = .init(x: 8,
                                y: bounds.midY - 8/2,
                                width: 8,
                                height: 8)
        label.frame = .init(x: indicator.frame.maxX + 8,
                            y: 0,
                            width: 80,
                            height: bounds.height)
        indicator.layer.cornerRadius = indicator.frame.height/2
        layer.cornerRadius = 4
    }
    
    
    private func setupView(){
        backgroundColor = .backgroundBlue
        addSubview(indicator)
        addSubview(label)
    }
}
