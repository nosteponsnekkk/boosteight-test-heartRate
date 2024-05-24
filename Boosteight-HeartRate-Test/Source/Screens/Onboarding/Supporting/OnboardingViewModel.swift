//
//  OnboardingViewModel.swift
//  Boosteight-HeartRate-Test
//
//  Created by Oleg on 24.05.2024.
//

import UIKit
import Combine

public final class OnboardingViewModel: NSObject, ObservableObject {
    
    public let viewControllers: [UIViewController] = [
        OnboardingPageViewController(page: .first),
        OnboardingPageViewController(page: .second),
        OnboardingPageViewController(page: .third)
    ]
    
    @Published public var pageIndex = 0
    private var cancellables: Set<AnyCancellable> = []
    
    public func bind(completion: @escaping (_ pageIndex: Int) -> Void){
        $pageIndex
            .sink(receiveValue: completion)
            .store(in: &cancellables)
    }
    
}
extension OnboardingViewModel: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let vc = pendingViewControllers.first as? OnboardingPageViewController
        vc?.prepareForAnimation()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                              didFinishAnimating finished: Bool,
                              previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first as? OnboardingPageViewController,
              let index = viewControllers.firstIndex(of: currentVC) else { return }
        pageIndex = index
        currentVC.performAnimation()
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard viewControllers.count > previousIndex else {
            return nil
        }
        
        return viewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard viewControllers.count != nextIndex else {
            return nil
        }
        
        guard viewControllers.count > nextIndex else {
            return nil
        }
        
        return viewControllers[nextIndex]
    }
    
}
