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
    
    enum SnapshotDevice {
        static let iPhone11 = CGSize(width: 414, height: 896)
        static let iPhoneSE = CGSize(width: 320, height: 568)
    }
    
    override class func setUp() {
        super.setUp()
        UserDefaults.standard.set(["ru"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
    }
    
    func testOnboardingFirstPage() {
        let page = OnboardingPage(imageName: Resources.OnboardingImage.onBoardingBlue.imageName,
                                  titleText: NSLocalizedString("label.onBoardingBlue", comment: ""),
                                  index: 0,
                                  total: 2)
        
        let vc = OnboardingPageViewController(page: page)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11), record: false)
    }
    
    func testOnboardingSecondPage() {
        let page = OnboardingPage(imageName: Resources.OnboardingImage.onBoardingRed.imageName,
                                  titleText: NSLocalizedString("label.onBoardingRed", comment: ""),
                                  index: 1, total: 2)
        
        let vc = OnboardingPageViewController(page: page)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11), record: false)
    }
    
    func testTrackerViewControllerLight(){
        let vc = TrackerViewController()
        let traits = UITraitCollection(userInterfaceStyle: .light)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11, traits: traits), record: false)
    }
    
    func testTrackerViewControllerLightDark(){
        let vc = TrackerViewController()
        let traits = UITraitCollection(userInterfaceStyle: .dark)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11, traits: traits), record: false)
    }
    
    
    func testTrackerTypeViewControllerLight(){
        let vc = TrackerTypeViewController()
        let traits = UITraitCollection(userInterfaceStyle: .light)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11, traits: traits), record: false)
    }
    
    func testTrackerTypeViewControllerDark(){
        let vc = TrackerTypeViewController()
        let traits = UITraitCollection(userInterfaceStyle: .dark)
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11, traits: traits), record: false)
    }
    
    func testScheduleViewController(){
        let vc = ScheduleViewController()
        assertSnapshot(of: vc, as: .image(size: Self.SnapshotDevice.iPhone11), record: false)
    }
}
