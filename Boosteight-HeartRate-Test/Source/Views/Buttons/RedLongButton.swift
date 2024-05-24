//
//  RedLongButton.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public final class RedLongButton: UIButton {
    
    private let action: () -> Void
    
    //MARK: - Init
    init(title: String, action: @escaping () -> Void){
        self.action = action
        super.init(frame: .zero)
        titleLabel?.textColor = .white
        titleLabel?.font = .rubikMedium(ofSize: 16)
        titleLabel?.textAlignment = .center
        setTitle(title, for: .normal)
        backgroundColor = .brandOrange
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
    
    //MARK: - Methods
    @objc private func didTapButton(){
        action()
    }
    
    //MARK: - Animation + Exclusive touch
    public override var isMultipleTouchEnabled: Bool {
        get {
            return false
        }
        set {}
    }
    public override var isExclusiveTouch: Bool {
        get {
            return true
        }
        set {
            
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {


        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) { [weak self] in
            guard let self else { return }
            transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
        super.touchesBegan(touches, with: event)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) { [weak self] in
            guard let self else { return }
            transform = .identity
        }
        super.touchesEnded(touches, with: event)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2) { [weak self] in
            guard let self else { return }
            transform = .identity
        }
        super.touchesCancelled(touches, with: event)
    }
}
