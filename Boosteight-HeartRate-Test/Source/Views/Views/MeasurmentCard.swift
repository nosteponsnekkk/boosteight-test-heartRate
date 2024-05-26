//
//  MeasurmentCard.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class MeasurmentCard: UIView {
    
    let model: HeartMeasurement
    
    //MARK: - Subviews
    private lazy var resultHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш Результат"
        label.textColor = .black
        label.font = .rubikMedium(ofSize: 18)
        return label
    }()
    private lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikSemiBold(ofSize: 28)
        switch model.result {
        case 0..<60:
            label.textColor = .slow
            label.text = "Уповільнений"
        case 60..<100:
            label.textColor = .normal
            label.text = "Звичайний"
        default:
            label.textColor = .fast
            label.text = "Прискорений"
        }
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = model.date.toString()
        label.font = .rubikRegular(ofSize: 16)
        label.numberOfLines = 2
        label.textColor = .brandGray
        return label
    }()
    private lazy var clockIcon: UIImageView = {
        let iv = UIImageView(image: .clock.withRenderingMode(.alwaysTemplate))
        iv.tintColor = .brandGray
        return iv
    }()
    private lazy var slider: CustomSlider = {
        let slider = CustomSlider()
        return slider
    }()
    private var infoIndicators: [MeasurmentSectionInfo] = [
        .init(type: .slow),
        .init(type: .normal),
        .init(type: .fast)
    ]
    private var infoLabels: [MeasurementInfoLabel] = [
        .init(type: .slow),
        .init(type: .normal),
        .init(type: .fast)
    ]
    
    //MARK: - Init
    init(model: HeartMeasurement) {
        self.model = model
        super.init(frame: .zero)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        resultHeaderLabel.frame = .init(x: 20,
                                        y: 20,
                                        width: 135,
                                        height: 22)
        resultLabel.frame = .init(x: 20,
                                  y: resultHeaderLabel.frame.maxY + 10,
                                  width: 220,
                                  height: 30)
        timeLabel.frame = .init(x: bounds.maxX - 95 - 20,
                                y: 20,
                                width: 95,
                                height: 40)
        clockIcon.frame = .init(x: timeLabel.frame.minX - 5 - 18,
                                y: timeLabel.frame.midY - 18/2,
                                width: 18,
                                height: 18)
        slider.frame = .init(x: 20,
                             y: resultLabel.frame.maxY + 15,
                             width: bounds.width - 40,
                             height: 20)
        slider.setThumbPosition(model.result)
        for (index, indicator) in infoIndicators.enumerated() {
            indicator.frame = .init(x: 20,
                                    y: index == 0 ? (slider.frame.maxY + 20) : infoIndicators[index - 1].frame.maxY + 15,
                                    width: 122,
                                    height: 20)
        }
        for (index, label) in infoLabels.enumerated() {
            label.frame = .init(x: bounds.maxX - 72 - 20,
                                y: index == 0 ? (slider.frame.maxY + 20) : infoLabels[index - 1].frame.maxY + 15,
                                width: 72,
                                height: 20)
        }
    }
    
    //MARK: - Methods
    private func setupView(){
        backgroundColor = .white
        addSubview(resultHeaderLabel)
        addSubview(resultLabel)
        addSubview(timeLabel)
        addSubview(clockIcon)
        addSubview(slider)
        infoIndicators.forEach {
            addSubview($0)
        }
        infoLabels.forEach {
            addSubview($0)
            switch model.result {
            case 0..<60:
                $0.textColor = $0.type == .slow ? .black : .lightGray
            case 60..<100:
                $0.textColor = $0.type == .normal ? .black : .lightGray
            default:
                $0.textColor = $0.type == .fast ? .black : .lightGray
            }
            
        }
        layer.cornerRadius = 20
    }
    
    
}
