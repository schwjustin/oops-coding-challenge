//
//  DetailView.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/26/23.
//

import SDWebImageSwiftUI
import SwiftUI

struct DetailView: View {
  @EnvironmentObject var moviesViewModel: MoviesViewModel
  @ObservedObject var interfaceViewModel: InterfaceViewModel
  @GestureState private var dragAmount = CGFloat.zero

  var onDrag: () -> Void
  var onEnd: () -> Void

  var cardOffsetX: CGFloat {
    if interfaceViewModel.showDetail {
      return CardSizing.horizontalPosterMargin
    } else {
      return interfaceViewModel.selectedCardPosition.x
    }
  }

  var cardOffsetY: CGFloat {
    if interfaceViewModel.showDetail {
      return SafeAreaInsets.top
    } else {
      return interfaceViewModel.selectedCardPosition.y
    }
  }

  var body: some View {
    if let movie = interfaceViewModel.selectedMovie {
      ZStack {
        ScrollViewReader { reader in
          ScrollView(showsIndicators: false) {
            ZStack(alignment: .top) {
              // poster
              // zstack top alignment, hstack, and spacer keep align card to top left (x: 0, y: 0) to start
              // this allows for easy position adjustment with .offset
              VStack(spacing: 0) {
                Spacer(minLength: 0.0)
                  .frame(height: interfaceViewModel.showDetail ? 16 : 0)

                HStack {
                  CardView(
                    cardSelected: $interfaceViewModel.showDetail,
                    movie: movie
                  )
                  .offset(x: cardOffsetX, y: cardOffsetY)
                  .shadow(color: .black.opacity(!interfaceViewModel.showDetail ? 0 : 0.25), radius: 30, x: 0, y: 8)

                  Spacer()
                }
              }
              .id(0)

              VStack(spacing: 36) {
                Spacer()
                  .frame(height: CardSizing.posterHeight + SafeAreaInsets.top + 16)

                // title image
                if let url = URL(string: movie.titleImage ?? "") {
                  WebImage(url: url)
                    .resizable()
                    .transition(.fade(duration: 0.15))
                    .scaledToFill()
                    .frame(width: CardSizing.posterWidth)
                }

                // description
                Text(movie.description ?? "")
                  .fontWeight(.medium)
                  .foregroundColor(.white)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 32)
                  .fixedSize(horizontal: false, vertical: true)

                Spacer()
                  .frame(height: SafeAreaInsets.bottom + 40)
              }
              .opacity(interfaceViewModel.showDetail ? 1.0 : 0.0)
            }
          }
          // account for scroll y offset when swipe back
          .onChange(of: interfaceViewModel.showDetail) { show in
            if !show {
              withAnimation {
                reader.scrollTo(0, anchor: .top)
              }
            }
          }
        }
        VStack(alignment: .trailing) {
          Spacer()

          HStack {
            Spacer()

            // blurred fab share button
            if let url = URL(string: movie.poster ?? "") {
              ShareLink(item: url, message: Text("\(movie.title ?? "")\n\n\(movie.description ?? "")")) {
                ZStack {
                  BlurView(.systemUltraThinMaterialDark)
                    .frame(width: 66, height: 66)
                    .mask(
                      Circle()
                    )

                  Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 28, height: 28)
                    .padding(.bottom, 4) // optical adjustment
                }
                .opacity(interfaceViewModel.showDetail ? 1.0 : 0.0)
                .padding(.bottom, SafeAreaInsets.bottom)
                .padding(.trailing, 20)
              }
            }
          }
        }
      }
      .background(
        PosterDetailBackground(movie: movie)
          .opacity(interfaceViewModel.showDetail ? 1.0 : 0.0)
      )
      .edgesIgnoringSafeArea(.all)
      .offset(x: interfaceViewModel.showDetail ? dragAmount / 2 : 0)
      .gesture(
        DragGesture().updating($dragAmount) { value, state, _ in
          // only allow swipe from left to right
          state = max(0, value.translation.width)

          // dismiss detail if swipe > 128
          if state > 128 {
            DispatchQueue.main.async {
              withAnimation(springAnimation) {
                onDrag()
              }
            }
          }
        }
        .onEnded { _ in
          if !interfaceViewModel.showDetail {
            withAnimation(springAnimation) {
              // hide detail uihostingcontroller when release drag and unhide cell
              onEnd()
            }
          }
        }
      )
    } else {
      EmptyView()
    }
  }
}
