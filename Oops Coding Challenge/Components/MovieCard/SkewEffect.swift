//
//  SkewEffect.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SwiftUI

struct SkewEffect: GeometryEffect, Animatable {
  var animatableData: CGFloat {
    get { skewProgress }
    set { skewProgress = newValue }
  }
  
  var skewProgress: CGFloat
  
  func effectValue(size: CGSize) -> ProjectionTransform {
    let skewX = -0.02 * (1 - skewProgress)
    let skewY = -0.15 * (1 - skewProgress)
    
    var transform = CGAffineTransform.identity
    transform.c = skewX
    transform.b = skewY
    return ProjectionTransform(transform)
  }
}
