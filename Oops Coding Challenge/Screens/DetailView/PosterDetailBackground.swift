//
//  PosterDetailBackground.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SDWebImageSwiftUI
import SwiftUI

struct PosterDetailBackground: View {
  @EnvironmentObject var moviesViewModel: MoviesViewModel

  let movie: Movie

  var computedBackgroundColor: Color {
    if let color = moviesViewModel.movies.first(where: { $0.id == movie.id })?.backgroundColor {
      return color
    } else {
      return .clear
    }
  }

  var darkerBackgroundColor: Color {
    let components = computedBackgroundColor.components()
    
    return Color(
      hue: Double(components.hue),
      saturation: max(0.0, Double(components.saturation) + Double(0.3)),
      brightness: min(1.0, Double(components.brightness) - Double(0.3)),
      opacity: 1.0
    )
  }

  var lighterBackgroundColor: Color {
    let components = computedBackgroundColor.components()

    return Color(
      hue: Double(components.hue),
      saturation: max(0.0, Double(components.saturation) - Double(0.3)),
      brightness: min(1.0, Double(components.brightness) + Double(0.3)),
      opacity: 1.0
    )
  }

  var body: some View {
    ZStack {
      ZStack {
        Color.white

        // linear gradient in background
        if computedBackgroundColor != .clear {
          LinearGradient(gradient: Gradient(colors: [
            lighterBackgroundColor,
            darkerBackgroundColor
          ]), startPoint: .top, endPoint: .bottom)
            .opacity(0.6)
        }
      }

      // backdrop image
      if let url = URL(string: movie.backdrop ?? "") {
        VStack {
          WebImage(url: url)
            .resizable()
            .scaledToFill()
            .transition(.fade(duration: 0.15))
            .frame(height: screenHeight * 2 / 3)
            .mask(
              LinearGradient(gradient: Gradient(colors: [.white.opacity(0.45), .white.opacity(0.0)]), startPoint: .top, endPoint: .bottom)
            )

          Spacer()
        }
      }
    }
  }
}
