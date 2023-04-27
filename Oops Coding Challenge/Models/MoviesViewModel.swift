//
//  MoviesViewModel.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/27/23.
//

import SwiftUI

class MoviesViewModel: ObservableObject {
  @Published var movies: [Movie] = []

  init() {
    if movies.isEmpty {
      populate()
    }
  }

  func populate() {
    movies = [
      Movie(
        poster: "https://m.media-amazon.com/images/I/A1f7vq1AwuL.jpg",
        backdrop: "https://www.everythinglubbock.com/wp-content/uploads/sites/35/2021/12/f043c8e0e4bf49c89d90af3bfa1aa031.jpg?w=2560&h=1440&crop=1",
        titleImage: "https://www.themoviedb.org/t/p/original/98axt60Zm9GvbmQntEm6tduoEGt.png",
        title: "Everything Everywhere All at Once",
        description: "An aging Chinese immigrant is swept up in an insane adventure, where she alone can save what’s important to her by connecting with the lives she could have led in other universes."
      ),
      Movie(
        poster: "https://m.media-amazon.com/images/M/MV5BNDNmYTQzMDEtMmY0MS00OTNjLTk4MjItMDZhMzkzOGI3MzA0XkEyXkFqcGdeQXVyNjk5NDA3OTk@._V1_.jpg",
        backdrop: "https://static1.moviewebimages.com/wordpress/wp-content/uploads/2023/02/untitled-design-43-1.png",
        titleImage: "https://vgboxart.com/resources/logo/15165_war-for-the-planet-of-the-apes-prev.png",
        title: "War for the Planet of the Apes",
        description: "Caesar and his apes are forced into a deadly conflict with an army of humans led by a ruthless Colonel. After the apes suffer unimaginable losses, Caesar wrestles with his darker instincts and begins his own mythic quest to avenge his kind. As the journey finally brings them face to face, Caesar and the Colonel are pitted against each other in an epic battle that will determine the fate of both their species and the future of the planet."
      ),
    ]
  }
}
