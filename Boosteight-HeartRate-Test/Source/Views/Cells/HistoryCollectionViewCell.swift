//
//  HistoryCollectionViewCell.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class HistoryCollectionViewCell: UICollectionViewCell {
        
    private lazy var bpmLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikRegular(ofSize: 36)
        label.textColor = .black
        return label
    }()
    private lazy var separator: UIView = {
        let view = UIView()
        view.backgroundColor = .brandOrange
        return view
    }()
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .rubikRegular(ofSize: 24)
        label.textColor = .brandGray
        label.numberOfLines = 0
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        bpmLabel.frame = .init(x: 20, y: 0, width: 162, height: bounds.height)
        separator.frame.size = .init(width: 5, height: bounds.height - 20)
        separator.center = .init(x: bounds.midX, y: bounds.midY)
        dateLabel.frame = .init(x: separator.frame.maxX + 20, y: 0, width: 175, height: bounds.height)
        
        separator.layer.cornerRadius = 5/2
        layer.cornerRadius = 20
    }
    
    private func setupView(){
        backgroundColor = .white
        addSubview(bpmLabel)
        addSubview(separator)
        addSubview(dateLabel)
    }
    
    public func setup(with model: HeartMeasurement) {
        bpmLabel.text = "\(model.result) BPM"
        dateLabel.text = model.date.toString()
    }
}
