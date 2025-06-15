//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Алина on 15.06.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    
    private static let testSnapshotSize = CGSize(width: 414, height: 896)
    
    override class func setUp() {
        super.setUp()
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func testOnboardingFirstPage_iPhone11() {
        let page = OnboardingPage(imageName: Resources.OnboardingImage.onBoardingBlue.imageName,
                                  titleText: NSLocalizedString("label.onBoardingBlue", comment: ""),
                                  index: 0,
                                  total: 2)
        
        let vc = OnboardingPageViewController(page: page)
        assertSnapshot(of: vc, as: .image(size: Self.testSnapshotSize))
    }
    
    func testOnboardingSecondPage_iPhone11() {
        let page = OnboardingPage(imageName: Resources.OnboardingImage.onBoardingRed.imageName,
                                  titleText: NSLocalizedString("label.onBoardingRed", comment: ""),
                                  index: 1, total: 2)
        
        let vc = OnboardingPageViewController(page: page)
        assertSnapshot(of: vc, as: .image(size: Self.testSnapshotSize))
    }
    
    func testTrackerViewController_iPhone11(){
        let vc = TrackerViewController()
        assertSnapshot(of: vc, as: .image(size: Self.testSnapshotSize))
    }
    
    func testTrackerTypeViewController_iPhone11(){
        let vc = TrackerTypeViewController()
        assertSnapshot(of: vc, as: .image(size: Self.testSnapshotSize))
    }
    
    func testScheduleViewController_iPhone11(){
        let vc = ScheduleViewController()
        assertSnapshot(of: vc, as: .image(size: Self.testSnapshotSize))
    }
}
