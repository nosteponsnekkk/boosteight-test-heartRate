//
//  PageIndicator.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit

public final class PageIndicator: UIView {
    
    public var pageIndex: Int = 0 {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                let cells = collectionView.visibleCells as? [IndicatorCellCollectionViewCell]
                cells?.forEach { $0.isActive = false }
                let cell = collectionView.cellForItem(at: .init(item: pageIndex, section: 0)) as? IndicatorCellCollectionViewCell
                collectionView.performBatchUpdates {
                    cell?.isActive = true
                }
            }
        }
    }
    private let numberOfItems: Int

    //MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(IndicatorCellCollectionViewCell.self)
        cv.isUserInteractionEnabled = false
        cv.backgroundColor = .white
        return cv
    }()
    
    //MARK: - Init
    init(numberOfItems: Int) {
        self.numberOfItems = numberOfItems
        super.init(frame: .zero)
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    //MARK: - Methods
    
}

extension PageIndicator: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: IndicatorCellCollectionViewCell.self, for: indexPath)
        cell.isActive = indexPath.item == pageIndex
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == pageIndex {
            return CGSize(width: collectionView.bounds.height * 3.14, height: collectionView.bounds.height)
        } else {
            return CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        }
    }
    
}

