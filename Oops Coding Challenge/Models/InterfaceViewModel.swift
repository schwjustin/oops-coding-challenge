//
//  InterfaceViewModel.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/26/23.
//

import SwiftUI

class InterfaceViewModel: ObservableObject {
  @Published var showDetail = false
  @Published var selectedCardPosition: CGPoint = .zero
  @Published var selectedMovie: Movie? = nil
}
