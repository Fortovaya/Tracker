//
//  ScheduleViewControllerDelegate.swift
//  Tracker
//
//  Created by Алина on 02.05.2025.
//
import Foundation

protocol ScheduleViewControllerDelegate: AnyObject {
    func scheduleViewController(_ controller: ScheduleViewController, didSelectDays days: Set<WeekDay>)
}
