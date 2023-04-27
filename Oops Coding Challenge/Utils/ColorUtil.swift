//
//  ColorUtil.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SwiftUI

public extension Color {
  func components() -> (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, opacity: CGFloat) {
    let color = UIColor(self)
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0

    color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

    return (hue, saturation, brightness, alpha)
  }
}
