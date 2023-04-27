//
//  MovieModel.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/26/23.
//

import SwiftUI

struct Movie: Hashable {
  var id: UUID = UUID()
  var poster: String?
  var backdrop: String?
  var titleImage: String?
  var title: String?
  var description: String?
  var backgroundColor: Color?
}
