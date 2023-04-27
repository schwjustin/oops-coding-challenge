//
//  CardCollectionViewCell.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/24/23.
//

import SwiftUI
import UIKit

class CardCollectionViewCell: UICollectionViewCell {
  static let reuseIdentifier = "CardCell"

  weak var delegate: CardCollectionViewCellDelegate?
  
  @objc private func didTapCell() {
    delegate?.didSelectCard(cell: self)
  }
}
