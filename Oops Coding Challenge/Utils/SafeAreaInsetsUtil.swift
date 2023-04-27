//
//  SafeAreaInsetsUtil.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/26/23.
//

import SwiftUI
import UIKit

class SafeAreaInsets {
  static var top: CGFloat {
    if #available(iOS 15.0, *) {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
      else {
        return 0
      }
      return window.safeAreaInsets.top
    }
  }

  static var bottom: CGFloat {
    if #available(iOS 15.0, *) {
      guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
      else {
        return 0
      }
      return window.safeAreaInsets.bottom
    }
  }
}
