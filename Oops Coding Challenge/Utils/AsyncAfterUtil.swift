//
//  AsyncAfterUtil.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/26/23.
//

import SwiftUI

func asyncAfter(_ duration: Double, completion: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
    completion()
  }
}
