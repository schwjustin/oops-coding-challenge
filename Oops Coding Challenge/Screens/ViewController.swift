//
//  ViewController.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/24/23.
//

import SwiftUI
import UIKit

func addConstraints(from: UIView, to: UIView) {
  NSLayoutConstraint.activate([
    from.leadingAnchor.constraint(equalTo: to.leadingAnchor),
    from.trailingAnchor.constraint(equalTo: to.trailingAnchor),
    from.topAnchor.constraint(equalTo: to.topAnchor),
    from.bottomAnchor.constraint(equalTo: to.bottomAnchor)
  ])
}

class ViewController: UIViewController, CollectionViewControllerDelegate {
  var interfaceViewModel = InterfaceViewModel()
  var moviesViewModel = MoviesViewModel()
  
  var hostingController: UIHostingController<AnyView>!
  var containerView: UIView!
  var selectedCell: CardCollectionViewCell?
  
  private func addCollectionGridViewController() {
    let collectionGridViewController = CollectionViewController(
      moviesViewModel: moviesViewModel,
      horizontalPadding: CardSizing.gridPadding,
      verticalPadding: 24,
      horizontalGridSpacing: CardSizing.cardSpacing,
      verticalGridSpacing: CardSizing.gridPadding
    )
    
    addChild(collectionGridViewController)
    collectionGridViewController.view.translatesAutoresizingMaskIntoConstraints = false
    containerView.addSubview(collectionGridViewController.view)
    
    collectionGridViewController.delegate = self
    
    addConstraints(from: collectionGridViewController.view, to: containerView)
    
    collectionGridViewController.didMove(toParent: self)
  }
  
  private func addDetailViewController() {
    let detailView = DetailView(
      interfaceViewModel: interfaceViewModel,
      onDrag: {
        self.interfaceViewModel.showDetail = false
      },
      onEnd: {
        asyncAfter(0.5) {
          self.interfaceViewModel.selectedMovie = nil
          self.hostingController.view.isHidden = true
          
          self.selectedCell?.isHidden = false
          self.selectedCell = nil
        }
      }
    )
    
    hostingController = UIHostingController(rootView: AnyView(detailView.environmentObject(moviesViewModel)))
    addChild(hostingController)
    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
    hostingController.view.backgroundColor = .clear
    hostingController.view.isHidden = true
    containerView.addSubview(hostingController.view)
    
    addConstraints(from: hostingController.view, to: containerView)
    
    hostingController.didMove(toParent: self)
  }
  
  func didSelectCardInCollectionViewController(cell: CardCollectionViewCell, movie: Movie, position: CGPoint) {
    interfaceViewModel.selectedCardPosition = position
    interfaceViewModel.selectedMovie = movie
    
    hostingController.view.isHidden = false
        
    selectedCell = cell
    
    asyncAfter(0.01) {
      cell.isHidden = true
    }
    
    asyncAfter(0.1) {
      withAnimation(springAnimation) {
        self.interfaceViewModel.showDetail = true
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    containerView = UIView()
    containerView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(containerView)
    
    addConstraints(from: containerView, to: view)

    addCollectionGridViewController()
    addDetailViewController()
  }
}
