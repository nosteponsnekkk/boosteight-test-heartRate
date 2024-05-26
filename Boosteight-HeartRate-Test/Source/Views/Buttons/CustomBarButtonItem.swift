//
//  CustomBarButtonItem.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class CustomBarButtonItem: UIBarButtonItem {

    let onTapAction: () -> Void
    let type: BarButtonConfiguration
    
    private lazy var button: HelperBarButton = {
        let btn = HelperBarButton(type: type, action: onTapAction)
        return btn
    }()
    
    init(type: BarButtonConfiguration, action: (() -> Void)? = nil){
        self.onTapAction = action ?? {}
        self.type = type
        super.init()
        customView = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc private func performAction(){
        onTapAction()
    }
    
    public func setSize(_ size: CGSize) {
        let currWidth = customView?.widthAnchor.constraint(equalToConstant: size.width)
        currWidth?.isActive = true
        let currHeight = customView?.heightAnchor.constraint(equalToConstant: size.height)
        currHeight?.isActive = true
    }
}
