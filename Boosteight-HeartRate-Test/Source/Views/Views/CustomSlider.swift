//
//  CustomSlider.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class CustomSlider: UIView {
    
    
    private let thumbWidth: CGFloat = 8
    private let thumbHeight: CGFloat = 20
    private let trackHeight: CGFloat = 12
    private var thumbPosition: CGFloat = 0.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    private lazy var thumb: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = thumbWidth/2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.brandGray.cgColor
        view.frame.size = .init(width: thumbWidth, height: thumbHeight)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        addSubview(thumb)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }
    
    public override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        let sectionWidth = rect.width / 3
        
        let trackRect = CGRect(x: 0, y: (rect.height - trackHeight) / 2, width: rect.width, height: trackHeight)
        let trackPath = UIBezierPath(roundedRect: trackRect, cornerRadius: trackHeight / 2)
        context?.addPath(trackPath.cgPath)
        context?.clip()
        
        context?.setFillColor(UIColor.slow.cgColor)
        context?.fill(CGRect(x: 0, y: (rect.height - trackHeight) / 2, width: sectionWidth, height: trackHeight))
        
        context?.setFillColor(UIColor.normal.cgColor)
        context?.fill(CGRect(x: sectionWidth, y: (rect.height - trackHeight) / 2, width: sectionWidth, height: trackHeight))
        
        context?.setFillColor(UIColor.fast.cgColor)
        context?.fill(CGRect(x: sectionWidth * 2, y: (rect.height - trackHeight) / 2, width: sectionWidth, height: trackHeight))
        
    }
    public override func layoutSubviews() {
        super.layoutSubviews()
        thumb.frame = .init(x: thumbPosition,
                            y: bounds.midY - thumbHeight/2,
                            width: thumbWidth,
                            height: thumbHeight)
    }
    
    func setThumbPosition(_ position: Int) {
        let clampedValue = CGFloat(max(min(position, 200), 0))
        let sectionWidth = bounds.width/3
        var newPosition: CGFloat = 0
        
        switch clampedValue {
        case 0..<60:
            let min: CGFloat = 0
            let range: CGFloat = 60
            newPosition = min + (sectionWidth * clampedValue/range)
        case 60..<100:
            let min: CGFloat = 1/3 * bounds.width
            let partOfSection: CGFloat = clampedValue - 60
            let range: CGFloat = 40
            newPosition = min + (sectionWidth * partOfSection/range)
        default:
            let min: CGFloat = 2/3 * bounds.width
            let partOfSection: CGFloat = clampedValue - 100
            let range: CGFloat = 100
            newPosition = min + (sectionWidth * partOfSection/range)
        }
        
        
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4) { [weak self] in
            guard let self else { return }
            thumbPosition = newPosition
            
        }
    }
    
    
}
