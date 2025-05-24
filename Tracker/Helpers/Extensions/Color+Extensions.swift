//
//  Color+Extensions.swift
//  Tracker
//
//  Created by Алина on 19.04.2025.
//
import UIKit

extension UIColor {
    static var ypWhite: UIColor {UIColor(named: "#FFFFFF") ?? UIColor.white }
    static var ypGray: UIColor {UIColor(named: "#AEAFB4") ?? UIColor.gray }
    static var ypBlue: UIColor {UIColor(named: "#3772E7") ?? UIColor.blue }
    static var ypBlack: UIColor {UIColor(named: "#1A1B22") ?? UIColor.black }
    static var ypDatePicker: UIColor {UIColor(named: "#F0F0F0") ?? UIColor.lightGray }
    static var ypSearchView: UIColor {UIColor(named: "#7676801F(12%)") ?? UIColor.lightGray }
    static var ypBackgroundTF: UIColor {UIColor(named: "#E6E8EB4D(30%)") ?? UIColor.lightGray }
    static var ypRed: UIColor{UIColor(named: "#F56B6C") ?? UIColor.red }
    static var ypToggle: UIColor{UIColor(named: "#E6E8EB") ?? UIColor.lightGray }
    static var backgroundNight: UIColor{UIColor(named: "#414141D9(85%)") ?? UIColor.gray }
    static var ypBlackBorder: UIColor {UIColor(named: "#000000") ?? UIColor.black }
    
    static var ypCellColorRed: UIColor { UIColor(named: "ypCellColorRed") ?? UIColor.red }
    static var ypCellColorOrange: UIColor { UIColor(named: "ypCellColorOrange") ?? UIColor.orange }
    static var ypCellColorBlue: UIColor { UIColor(named: "ypCellColorBlue") ?? UIColor.blue }
    static var ypCellColorPurple: UIColor { UIColor(named: "ypCellColorPurple") ?? UIColor.purple }
    static var ypCellColorGreen: UIColor { UIColor(named: "ypCellColorGreen") ?? UIColor.green }
    static var ypCellColorPink: UIColor { UIColor(named: "ypCellColorPink") ?? UIColor.systemPink }
    static var ypCellColorLightPink: UIColor { UIColor(named: "ypCellColorLightPink") ?? UIColor.systemPink }
    static var ypCellColorLightBlue: UIColor { UIColor(named: "ypCellColorLightBlue") ?? UIColor.systemBlue }
    static var ypCellColorMint: UIColor { UIColor(named: "ypCellColorMint") ?? UIColor.systemTeal }
    static var ypCellColorDarkBlue: UIColor { UIColor(named: "ypCellColorDarkBlue") ?? UIColor.systemIndigo }
    static var ypCellColorCoral: UIColor { UIColor(named: "ypCellColorCoral") ?? UIColor.systemOrange }
    static var ypCellColorBabyPink: UIColor { UIColor(named: "ypCellColorBabyPink") ?? UIColor.systemPink }
    static var ypCellColorPeach: UIColor { UIColor(named: "ypCellColorPeach") ?? UIColor.systemOrange }
    static var ypCellColorPeriwinkle: UIColor { UIColor(named: "ypCellColorPeriwinkle") ?? UIColor.systemBlue }
    static var ypCellColorViolet: UIColor { UIColor(named: "ypCellColorViolet") ?? UIColor.systemPurple }
    static var ypCellColorLavender: UIColor { UIColor(named: "ypCellColorLavender") ?? UIColor.systemPurple }
    static var ypCellColorLightPurple: UIColor { UIColor(named: "ypCellColorLightPurple") ?? UIColor.systemPurple }
    static var ypCellColorLime: UIColor { UIColor(named: "ypCellColorLime") ?? UIColor.systemGreen }
    
    static var trackerCellColors: [UIColor] {
        return [
            .ypCellColorRed,
            .ypCellColorOrange,
            .ypCellColorBlue,
            .ypCellColorPurple,
            .ypCellColorGreen,
            .ypCellColorPink,
            .ypCellColorLightPink,
            .ypCellColorLightBlue,
            .ypCellColorMint,
            .ypCellColorDarkBlue,
            .ypCellColorCoral,
            .ypCellColorBabyPink,
            .ypCellColorPeach,
            .ypCellColorPeriwinkle,
            .ypCellColorViolet,
            .ypCellColorLavender,
            .ypCellColorLightPurple,
            .ypCellColorLime
        ]
    }
}
