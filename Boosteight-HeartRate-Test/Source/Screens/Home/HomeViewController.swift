//
//  HomeViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 23.05.2024.
//

import UIKit
import AVFoundation

public final class HomeViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    
    private let viewModel: MeasurmentsViewModel
    
    //MARK: - Heart rate Managment
    var heartRateManager: HeartRateManager?
    lazy var measurmentView: MeasurementContainer = {
        let view = MeasurementContainer()
        view.alpha = 0
        return view
    }()
    var currentBPM: Float = .zero {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                animatedHeart.setPulse(currentBPM)
            }
        }
    }

    //MARK: - Subviews
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    private lazy var emptyDataLabel: UILabel = {
        let label = UILabel()
        label.text = "Виконайте своє перше\nвимірювання!"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .rubikSemiBold(ofSize: 28)
        label.isHidden = true
        label.numberOfLines = 2
        return label
    }()
    private lazy var measureButton: MeasureButton = {
        return MeasureButton(action: startMeasuring)
    }()
    private lazy var animatedHeart: AnimatedHeart = {
        return AnimatedHeart(animateOnStart: false, frame: .init(x: view.bounds.midX - 266/2,
                                                                 y: view.bounds.midY - 240/2,
                                                                 width: 266,
                                                                 height: 240))
    }()
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.close, for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(stopMeasuring), for: .touchUpInside)
        button.alpha = 0
        button.isHidden = true
        return button
    }()
    private lazy var instrutionsImageView: UIImageView = {
        let iv = UIImageView(image: .instructions)
        iv.alpha = 0
        return iv
    }()
    private lazy var progressView: ProgressView = {
        let view = ProgressView()
        view.alpha = 0
        return view
    }()
    
    //MARK: - Init
    init(_ viewModel: MeasurmentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        emptyDataLabel.sizeToFit()
        emptyDataLabel.center = .init(x: view.bounds.midX, y: view.safeAreaInsets.top + 75)
        
        bottomContainer.frame = .init(x: 0,
                                      y: view.bounds.maxY - view.bounds.height/4,
                                      width: view.bounds.width,
                                      height: view.bounds.height/4)
        measureButton.frame.size = .init(width: 114, height: 114)
        measureButton.center = .init(x: bottomContainer.bounds.midX,
                                     y: bottomContainer.bounds.midY + 20)
        measurmentView.frame = .init(x: 20,
                                     y: view.bounds.height/12,
                                     width: view.bounds.width - 40,
                                     height: 115)
        cancelButton.frame = .init(x: measurmentView.bounds.maxX - 15,
                                   y: measurmentView.bounds.minY,
                                   width: 15,
                                   height: 15)
        instrutionsImageView.frame = .init(x: view.bounds.midX - (141 * 0.9)/2 + 15,
                                           y: bottomContainer.frame.minY - 130,
                                           width: 141 * 0.9,
                                           height: 174 * 0.9)
        
        progressView.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 15)
        progressView.center = .init(x: view.bounds.midX, y: bottomContainer.frame.minY - 115)
    }
    
    //MARK: - Methods
    private func setupView(){
        view.backgroundColor = .backgroundBlue
        view.addSubview(emptyDataLabel)
        view.addSubview(bottomContainer)
        view.addSubview(animatedHeart)
        view.addSubview(measurmentView)
        view.addSubview(progressView)
        measurmentView.addSubview(cancelButton)
        view.addSubview(instrutionsImageView)
        bottomContainer.addSubview(measureButton)
        
        let navigationController = navigationController as? CustomNavigationController
        navigationController?.isNavigationBarHidden = false
        navigationController?.animateIn()
        let barButton = CustomBarButtonItem(type: .history, action: coordinator?.goHistory)
        barButton.setSize(.init(width: 120, height: 38))
        navigationItem.rightBarButtonItem = barButton
        animatedHeart.simpleAnimateIn()
    }
    private func bind(){
        viewModel.bind { [weak self] isDataEmpty in
            guard let self else { return }
            UIView.transition(with: emptyDataLabel, duration: 0.3, options: .transitionCrossDissolve) {
                self.emptyDataLabel.isHidden = !isDataEmpty
            }
        }
    }
    private func startMeasuring(){
        prepareForMeasuring()
        initVideoCapture()

    }
    private func prepareForMeasuring(){
        cancelButton.isHidden = false
        instrutionsImageView.transform = .identity.translatedBy(x: 0, y: 80)
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.emptyDataLabel.alpha = 0
            self?.measureButton.alpha = 0
            self?.cancelButton.alpha = 1
            self?.measurmentView.alpha = 1
        }
        
        let navigationController = navigationController as? CustomNavigationController
        navigationController?.animateOut()
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.animatedHeart.frame.origin.y -= 80
            self?.animatedHeart.prepareForMeasurment()
            self?.instrutionsImageView.alpha = 1
            self?.instrutionsImageView.transform = .identity
        } completion: { [weak self] _ in
            self?.animatedHeart.startPulse()
        }
    }
        
    @objc private func stopMeasuring(){
        animatedHeart.stopPulse()
        deinitCaptureSession()
        navigationController?.isNavigationBarHidden = false
        let navigationController = navigationController as? CustomNavigationController
        navigationController?.animateIn()
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.animatedHeart.frame.origin.y += 80
            self?.animatedHeart.stopMeasurment()
            self?.instrutionsImageView.alpha = 0
            self?.measurmentView.alpha = 0
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.emptyDataLabel.alpha = 1
            self?.measureButton.alpha = 1
            self?.cancelButton.alpha = 0
            self?.progressView.alpha = 0
        } completion: { [weak self] _ in
            self?.cancelButton.isHidden = true
        }
        currentBPM = .zero
    }
    
}
extension HomeViewController: HeartManagmentDelegate {
    public func getProgress(progress: CGFloat) {
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.prepare()
        haptic.impactOccurred()

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            cancelButton.isHidden = progress != .zero
            
            UIView.animate(withDuration: 0.3) {
                if progress == .zero {
                    self.instrutionsImageView.alpha = 1
                    self.progressView.alpha = 0
                } else {
                    self.instrutionsImageView.alpha = 0
                    self.progressView.alpha = 1
                }
            }
            
            progressView.progress = progress
        }
    }
    
    public func didCompleteRating(heartRate bpm: Int?) {
        guard let bpm else { return }
        currentBPM = Float(bpm)
        progressView.progress = 1
        let model = HeartMeasurement(date: .now, result: bpm)
        viewModel.createMeasurement(model)
        let haptic = UIImpactFeedbackGenerator(style: .soft)
        haptic.prepare()
        haptic.impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.stopMeasuring()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.coordinator?.openDetail(for: model)
        }
    }
    
    
}
