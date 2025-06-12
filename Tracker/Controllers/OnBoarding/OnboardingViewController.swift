//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Алина on 12.06.2025.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    //MARK: Enum
    private enum Constants {
        static let horizontalInset: CGFloat = 20
        static let bottomOffset: CGFloat = 50
        static let stackSpacing: CGFloat = 24
    }
    
    private enum OnboardingStep: Int, CaseIterable {
        case onBoardingBlue
        case onBoardingRed
        
        private var imageName: String {
            switch self {
                case .onBoardingBlue:
                    return Resources.OnboardingImage.onBoardingBlue.imageName
                case .onBoardingRed:
                    return Resources.OnboardingImage.onBoardingRed.imageName
            }
        }
        
        private var titleText: String {
            switch self {
                case .onBoardingBlue:
                    return Resources.OnBoardingLabel.onBoardingBlue.text
                case .onBoardingRed:
                    return Resources.OnBoardingLabel.onBoardingRed.text
            }
        }
        
        var page: OnboardingPage {
            .init(imageName: imageName,
                  titleText: titleText,
                  index: rawValue,
                  total: OnboardingStep.allCases.count)
        }
    }
    
    //MARK: - Private variables
    private lazy var pages: [OnboardingPageViewController] = OnboardingStep.allCases.map { step in
        OnboardingPageViewController(page: step.page)
    }
    
    private lazy var boardingButton = BaseButton(title: .onBoarding,
                                                 target: self,
                                                 action: #selector(didTapBoardingButton))
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = .zero
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [pageControl,boardingButton])
        stack.axis = .vertical
        stack.spacing = Constants.stackSpacing
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupInitialPage()
        configurationOnBoardingViewController()
    }
    
    //MARK: - Private Methods
    private func setupInitialPage() {
        guard let first = pages.first else { return }
        setViewControllers([first], direction: .forward, animated: false)
    }
    
    private func configurationOnBoardingViewController(){
        view.addSubviews([bottomStackView])
        [bottomStackView, boardingButton].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                      constant: -Constants.horizontalInset),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                     constant: Constants.horizontalInset),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                    constant: -Constants.bottomOffset),
            
            boardingButton.widthAnchor.constraint(equalTo: bottomStackView.widthAnchor)
            
        ])
        
        pageControl.addTarget(self, action: #selector(pageControlTapped(_:)), for: .valueChanged)
    }
    
    //MARK: - Private Action
    @objc private func didTapBoardingButton(){
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first
        else {
            assertionFailure("Invalid window configuration")
            return
        }
        let mainTabBarController = MainTabBarController ()
        window.rootViewController = mainTabBarController
    }
    
    @objc private func pageControlTapped(_ sender: UIPageControl) {
        let newIndex = sender.currentPage
        guard
            let current = viewControllers?.first as? OnboardingPageViewController,
            let currentIndex = pages.firstIndex(of: current)
        else { return }
        
        let direction: UIPageViewController.NavigationDirection = newIndex > currentIndex ? .forward : .reverse
        
        sender.isEnabled = false
        
        setViewControllers([pages[newIndex]], direction: direction, animated: true) { [weak self] _ in
            guard let self = self else { return }
            self.pageControl.currentPage = newIndex
            sender.isEnabled = true
        }
    }
}
//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard
            let viewControllerIndex = viewController as? OnboardingPageViewController,
            let index = pages.firstIndex(of: viewControllerIndex),
            index > 0
        else {
            return nil
        }
        
        let previousIndex = index - 1
        guard previousIndex >= 0 else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard
            let viewControllerIndex = viewController as? OnboardingPageViewController,
            let index = pages.firstIndex(of: viewControllerIndex),
            index < pages.count - 1
        else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}
//MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let current = viewControllers?.first,
              let index = pages.firstIndex(of: current as! OnboardingPageViewController)
        else { return }
        pageControl.currentPage = index
    }
}
