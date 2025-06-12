//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Алина on 12.06.2025.
//

import UIKit

final class OnboardingPageViewController: UIViewController {
    //MARK: Enum
    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let bottomOffset: CGFloat = 270
    }
    // MARK: - Private variables
    private let page: OnboardingPage
    
    private lazy var imageBoarding: UIImageView = {
        let imageBoarding = UIImageView()
        imageBoarding.image = UIImage(named: page.imageName)
        imageBoarding.contentMode = .scaleAspectFit
        imageBoarding.translatesAutoresizingMaskIntoConstraints = false
        return imageBoarding
    }()
    
    private lazy var labelBoarding: UILabel = {
        let labelBoarding = UILabel()
        labelBoarding.font = .systemFont(ofSize: 32, weight: .bold)
        labelBoarding.text = page.titleText
        labelBoarding.numberOfLines = 2
        labelBoarding.textAlignment = .center
        labelBoarding.textColor = .ypBlack
        labelBoarding.translatesAutoresizingMaskIntoConstraints = false
        return labelBoarding
    }()
    // MARK: - Init
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder){
        assertionFailure("init(coder:) не поддерживается")
        return nil
    }
    // MARK: - Life Cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        configurationOnBoardingPageController()
        
    }
    //MARK: - Private Methods
    private func configurationOnBoardingPageController(){
        view.addSubviews([imageBoarding, labelBoarding])
        [imageBoarding, labelBoarding].disableAutoresizingMask()
        
        NSLayoutConstraint.activate([
            imageBoarding.topAnchor.constraint(equalTo: view.topAnchor),
            imageBoarding.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageBoarding.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageBoarding.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            labelBoarding.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                    constant: -Constants.horizontalPadding),
            labelBoarding.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                   constant: Constants.horizontalPadding),
            labelBoarding.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                  constant: -Constants.bottomOffset),
        ])
        
        view.backgroundColor = .ypWhite
    }
}
