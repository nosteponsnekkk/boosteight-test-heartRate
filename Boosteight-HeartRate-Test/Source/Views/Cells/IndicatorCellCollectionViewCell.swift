//
//  IndicatorCellCollectionViewCell.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public final class IndicatorCellCollectionViewCell: UICollectionViewCell {
   
    public var isActive = false {
        didSet {
            UIView.animate(withDuration: 0.3) { [weak self] in
                guard let self else { return }
                backgroundColor = isActive ? .brandOrange : .brandLightGray
            }
        }
    }
    
    //MARK: - Init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .brandLightGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}
