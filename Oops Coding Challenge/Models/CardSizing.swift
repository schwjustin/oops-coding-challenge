//
//  CardSizing.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SwiftUI

class CardSizing {
  static let aspectRatio: CGFloat = 9 / 5
  static let cardSpacing: CGFloat = 18
  static let gridPadding: CGFloat = 24
  
  static var cardWidth: CGFloat {
    (screenWidth - 2 * cardSpacing - 2 * gridPadding) / 3
  }
  
  static var cardHeight: CGFloat {
    return cardWidth * aspectRatio
  }
  
  static let posterWidth: CGFloat = screenWidth * 0.7
  
  static var posterHeight: CGFloat {
    return posterWidth * aspectRatio
  }
  
  static let horizontalPosterMargin: CGFloat = screenWidth * 0.15
  
  static func dynamicCardHeight(_ cardSelected: Bool) -> CGFloat {
    if cardSelected {
      return CardSizing.posterHeight
    } else {
      return CardSizing.cardHeight
    }
  }
  
  static func dynamicCardWidth(_ cardSelected: Bool) -> CGFloat {
    if cardSelected {
      return CardSizing.posterWidth
    } else {
      return CardSizing.cardWidth
    }
  }
}
