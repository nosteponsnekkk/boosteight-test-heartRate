//
//  HistoryViewController.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 26.05.2024.
//

import UIKit

public final class HistoryViewController: UIViewController {
    
    weak var coordinator: HomeCoordinator?
    private let viewModel: MeasurmentsViewModel
    
    private var shallMoveButton: Bool {
        let offset: CGFloat = 15
        let numberOfItems = CGFloat(viewModel.measurments.count)
        let itemHeight: CGFloat = 98
        let totalSpace = numberOfItems * (itemHeight) + (numberOfItems - 1) * offset + 20
        return totalSpace >= view.bounds.height - view.bounds.height/4
    }
    
    //MARK: - Subviews
    private lazy var bottomContainer: BottomContainerView = {
        let view = BottomContainerView()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
        return view
    }()
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.delegate = self
        cv.dataSource = self
        cv.register(HistoryCollectionViewCell.self)
        cv.backgroundColor = .clear
        return cv
    }()
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Відсутні збереженні\nвимірювання"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .rubikSemiBold(ofSize: 28)
        label.isHidden = true
        label.numberOfLines = 2
        return label
    }()
    private var clearButton: RedLongButton?
    
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
        bottomContainer.frame = .init(x: 0,
                                      y: view.bounds.maxY - view.bounds.height/4,
                                      width: view.bounds.width,
                                      height: view.bounds.height/4)
        clearButton?.frame.size = .init(width: bottomContainer.bounds.width - bottomContainer.bounds.width/8, height: 44)
        placeholderLabel.sizeToFit()
        placeholderLabel.center = .init(x: view.bounds.midX, y: view.bounds.midY - 40)
        
        let offset: CGFloat = 15
        let numberOfItems = CGFloat(viewModel.measurments.count)
        let itemHeight: CGFloat = 98
        let totalSpace = numberOfItems * (itemHeight) + (numberOfItems - 1) * offset
        
        collectionView.frame = .init(x: 0, y: 0,
                                     width: view.bounds.width,
                                     height: totalSpace)
        
        scrollView.frame = .init(x: 0, y: navigationController?.navigationBar.frame.maxY ?? .zero,
                                 width: view.bounds.width,
                                 height: view.bounds.height - (navigationController?.navigationBar.frame.maxY ?? .zero))
        
        if shallMoveButton {
            scrollView.contentSize = .init(width: collectionView.frame.size.width, height: totalSpace + 40 + (clearButton?.frame.height ?? 0) + 10)
            clearButton?.center = CGPoint(x: scrollView.bounds.midX, y: collectionView.frame.maxY + (clearButton?.frame.height ?? 0)/2 + 20)
        } else {
            scrollView.contentSize = .init(width: collectionView.frame.size.width, height: totalSpace + 20)
            clearButton?.center = CGPoint(x: bottomContainer.frame.midX, y: bottomContainer.frame.midY + 44 - 14)
        }
    }
    
    //MARK: - Methods
    private func setupView(){
        title = "Історія"
        view.backgroundColor = .backgroundBlue
        view.addSubview(bottomContainer)
        navigationItem.setHidesBackButton(true, animated: true)
        let menuBarItem = CustomBarButtonItem(type: .back, action: coordinator?.goHome)
        menuBarItem.setSize(.init(width: 50, height: 25))
        self.navigationItem.leftBarButtonItem = menuBarItem
        
        view.addSubview(placeholderLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        
        setupButton(viewModel.measurments.isEmpty)
    }
    
    private func setupButton(_ shallHide: Bool = false){
        clearButton?.removeFromSuperview()
        clearButton = nil
        guard !shallHide else { return }
        clearButton = .init(title: "Очистити історію", action: clearHistory)
        if !shallMoveButton {
            if let clearButton {
                view.addSubview(clearButton)
                viewDidLayoutSubviews()
                view.bringSubviewToFront(clearButton)
            }
        } else {
            if let clearButton {
                scrollView.addSubview(clearButton)
                viewDidLayoutSubviews()
                scrollView.bringSubviewToFront(clearButton)
            }

        }
    }
    
    private func clearHistory(){
        presentAlert(withTitle: "Ви впевненні?",
                     withMessage: "Ви впевненні що хочете видалити всі ваші вимірювання?",
                     withCancelTitle: "Ні",
                     withConfirmTitle: "Так") { [weak self] in
            guard let self else { return }
            viewModel.deleteAllMeasurements()
        }
    }
    
    
    private func bind(){
        viewModel.bind { [weak self] isDataEmpty in
            guard let self else { return }
            setupButton(isDataEmpty)
            UIView.transition(with: collectionView, duration: 0.3, options: .transitionCrossDissolve) {
                self.placeholderLabel.isHidden = !isDataEmpty
                self.collectionView.reloadData()
            }
        }
    }
    
}
extension HistoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.measurments.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: HistoryCollectionViewCell.self, for: indexPath)
        cell.setup(with: viewModel.measurments[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.width - 30, height: 98)
    }
    
}
