//
//  CardView.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/24/23.
//

import SDWebImageSwiftUI
import SwiftUI
import UIImageColors

struct CardView: View {
  @EnvironmentObject var moviesViewModel: MoviesViewModel
  @Binding var cardSelected: Bool
  @State private var offsets: CGRect = .zero
  
  let movie: Movie
  
  var corners: CGFloat {
    return cardSelected ? 20 : 12
  }
  
  var computedBackgroundColor: Color {
    if let color = moviesViewModel.movies.first(where: { $0.id == movie.id })?.backgroundColor {
      return color
    } else {
      return .clear
    }
  }
  
  var lighterBackgroundColor: Color {
    let components = computedBackgroundColor.components()
    
    return Color(
      hue: Double(components.hue),
      saturation: max(0.0, Double(components.saturation) - Double(0.2)),
      brightness: min(1.0, Double(components.brightness) + Double(0.2)),
      opacity: 1.0
    )
  }
  
  var darkerStrokeColor: Color {
    let components = computedBackgroundColor.components()
    
    return Color(
      hue: Double(components.hue),
      saturation: Double(components.saturation),
      brightness: min(1.0, Double(components.brightness) - Double(0.2)),
      opacity: 1.0
    )
  }
  
  var lighterStrokeColor: Color {
    let components = computedBackgroundColor.components()
    
    return Color(
      hue: Double(components.hue),
      saturation:  max(0.0, Double(components.saturation) - Double(0.25)),
      brightness: min(1.0, Double(components.brightness) + Double(0.25)),
      opacity: 1.0
    )
  }
  
  var body: some View {
    VStack {
      ZStack {
        if let url = URL(string: movie.poster ?? "") {
          // poster image
          WebImage(url: url)
            .resizable()
            .onSuccess { image, _, _ in
              image.getColors { colors in
                if let secondary = colors?.secondary {
                  if let index = moviesViewModel.movies.firstIndex(where: { $0.id == movie.id }) {
                    moviesViewModel.movies[index].backgroundColor = Color(uiColor: secondary)
                  }
                }
              }
            }
            .transition(.fade(duration: 0.15))
            .scaledToFill()
            .frame(
              width: CardSizing.dynamicCardWidth(cardSelected),
              height: CardSizing.dynamicCardHeight(cardSelected)
            )
        }
      }
      .mask(RoundedRectangle(cornerRadius: corners, style: .continuous))
      // gradient card background with stroke
      .background(
        Group {
          if computedBackgroundColor != .clear {
            RoundedRectangle(cornerRadius: corners + 2, style: .continuous)
              .fill(
                LinearGradient(gradient: Gradient(colors: [
                  computedBackgroundColor,
                  lighterBackgroundColor
                ]), startPoint: .top, endPoint: .bottom),
                strokeBorder: LinearGradient(gradient: Gradient(colors: [
                  lighterStrokeColor,
                  darkerStrokeColor.opacity(0.33)
                ]), startPoint: .top, endPoint: .bottom),
                lineWidth: 2
              )
              .opacity(0.7)
              .offset(
                x: cardSelected ? 0 : -4,
                y: cardSelected ? 0 : -4
              )
          }
        }
      )
      // subtle drop shadow
      .shadow(color: .black.opacity(cardSelected ? 0 : 0.15), radius: 15, x: 0, y: 8)
      // skew effect
      .modifier(SkewEffect(skewProgress: cardSelected ? 1 : 0))
      // offset to center card after skew effect
      .offset(
        x: cardSelected ? 0 : -offsets.minX / 2,
        y: cardSelected ? 0 : -offsets.minY / 2
      )
      .animation(springAnimation, value: cardSelected)
    }
    .onAppear {
      // calculate offsets for center view after skew effect
      calculateTransformedSize()
    }
  }
  
  func calculateTransformedSize() {
    let originalRect = CGRect(x: 0, y: 0, width: CardSizing.cardWidth, height: CardSizing.cardHeight)
    let transformedRect = originalRect.applying(CGAffineTransform(a: 1.0, b: cardSelected ? 0 : -0.15, c: cardSelected ? 0 : -0.02, d: 1.0, tx: 0, ty: 0))
    
    offsets = transformedRect
  }
}
