//
//  FooterViewDelegate.swift
//  Tracker
//
//  Created by Алина on 09.05.2025.
//
import Foundation

protocol FooterViewDelegate: AnyObject {
    func footerViewDidTapPlusButton(_ footerView: FooterView, inSection section: Int)
}
