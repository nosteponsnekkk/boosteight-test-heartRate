//
//  PageIndicator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public final class PageIndicator: UIView {
    
    public var offset: CGFloat = 0 {
        didSet {
            configureAnimation(offset: offset)
        }
    }
    
    private let numberOfPages: Int
    private var dots: [UIView] = []
    
    init(numberOfPages: Int) {
        self.numberOfPages = numberOfPages
        super.init(frame: .zero)
        setupView()
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        for _ in 0..<numberOfPages {
            let dot = UIView()
            dots.append(dot)
            dot.backgroundColor = .brandLightGray
            addSubview(dot)
        }
        setupDotsLayout()
    }
    
    private func setupDotsLayout() {
        for (index, dot) in dots.enumerated() {
            var x: CGFloat = 0
            var width: CGFloat = 14
            if index == 0 {
                x = 0
                width *= 3.14
                dot.backgroundColor = .brandOrange
            } else {
                x = dots[index - 1].frame.maxX + 5
            }
            dot.frame = .init(x: x,
                              y: 0,
                              width: width,
                              height: 14)
            dot.layer.cornerRadius = 14 / 2
        }
    }
    
    //MARK: - Animation
    private func configureAnimation(offset: CGFloat) {
        guard numberOfPages > 0 else { return }
        guard let pageWidth = window?.windowScene?.screen.bounds.width else { return }
        
        let fractionalPageIndex = offset / pageWidth
        let currentPageIndex = Int(fractionalPageIndex)
        let progress = fractionalPageIndex - CGFloat(currentPageIndex)
        
        for (index, dot) in dots.enumerated() {
            let dotWidth = calculateDotWidth(index: index, currentPageIndex: currentPageIndex, progress: progress)
            let dotColor = calculateDotColor(index: index, currentPageIndex: currentPageIndex, progress: progress)
            let dotX = calculateDotXPosition(index: index)
            
            animateDot(dot: dot, toWidth: dotWidth, toX: dotX, toColor: dotColor)
        }
    }
    private func calculateDotWidth(index: Int, currentPageIndex: Int, progress: CGFloat) -> CGFloat {
        let baseWidth = bounds.height
        if index == currentPageIndex {
            return baseWidth + (baseWidth * 2.14 * (1 - progress))
        } else if index == currentPageIndex + 1 {
            return baseWidth + (baseWidth * 2.14 * progress)
        } else {
            return baseWidth
        }
    }
    private func calculateDotColor(index: Int, currentPageIndex: Int, progress: CGFloat) -> UIColor {
        if currentPageIndex == 0 && progress < 0 { // Scrolling back from the first dot
            if index == 0 {
                return .brandOrange
            } else {
                return .brandLightGray
            }
        } else if currentPageIndex == numberOfPages - 1 && progress > 0 { // Scrolling forward from the last dot
            if index == numberOfPages - 1 {
                return .brandOrange
            } else {
                return .brandLightGray
            }
        } else { // Normal behavior
            if index == currentPageIndex {
                return interpolateColor(from: .brandOrange, to: .brandLightGray, progress: progress)
            } else if index == currentPageIndex + 1 {
                return interpolateColor(from: .brandLightGray, to: .brandOrange, progress: progress)
            } else {
                return .brandLightGray
            }
        }
    }
    private func calculateDotXPosition(index: Int) -> CGFloat {
        if index == 0 {
            return 0
        } else {
            return dots[index - 1].frame.maxX + 5
        }
    }
    private func interpolateColor(from startColor: UIColor, to endColor: UIColor, progress: CGFloat) -> UIColor {
        var startRed: CGFloat = 0, startGreen: CGFloat = 0, startBlue: CGFloat = 0, startAlpha: CGFloat = 0
        var endRed: CGFloat = 0, endGreen: CGFloat = 0, endBlue: CGFloat = 0, endAlpha: CGFloat = 0
        
        startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
        endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
        
        let red = startRed + (endRed - startRed) * progress
        let green = startGreen + (endGreen - startGreen) * progress
        let blue = startBlue + (endBlue - startBlue) * progress
        let alpha = startAlpha + (endAlpha - startAlpha) * progress
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    private func animateDot(dot: UIView, toWidth width: CGFloat, toX x: CGFloat, toColor color: UIColor) {
        UIView.animate(withDuration: 0.3) {
            dot.frame = .init(x: x, y: 0, width: width, height: dot.frame.height)
            dot.backgroundColor = color
        }
    }
}
