//
//  OnboardingViewModel.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit
import Combine

public final class OnboardingViewModel: NSObject, ObservableObject {
    
    @Published public var pageIndex = 0
    @Published private var offset: CGFloat = 0
    private var cancellables: Set<AnyCancellable> = []
    
    public func bind(pageIndex: @escaping (_ pageIndex: Int) -> Void,
                     offset: @escaping (_ offset: CGFloat) -> Void){
        $pageIndex
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: pageIndex)
            .store(in: &cancellables)
        
        $offset
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: offset)
            .store(in: &cancellables)
    }
    
}

extension OnboardingViewModel: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return OnboardingPage.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: OnboardingPageCollectionViewCell.self, for: indexPath)
        cell.setPage(page: OnboardingPage.allCases[indexPath.item])
        return cell
        
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? OnboardingPageCollectionViewCell {
            cell.performAnimation()
        }
    }
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentSize != .zero else { return }
        let numberOfPages = OnboardingPage.allCases.count
        let pageSize = scrollView.contentSize.width / CGFloat(numberOfPages)
        let offset = scrollView.contentOffset.x
        pageIndex = Int(offset / pageSize)
        
        self.offset = offset
    }
 
}
