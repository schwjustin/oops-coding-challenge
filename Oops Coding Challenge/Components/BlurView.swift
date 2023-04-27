//
//  BlurView.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
  let style: UIBlurEffect.Style
  
  init(_ style: UIBlurEffect.Style = .systemThinMaterial) {
    self.style = style
  }
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    return UIVisualEffectView(effect: UIBlurEffect(style: style))
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = UIBlurEffect(style: style)
  }
}
