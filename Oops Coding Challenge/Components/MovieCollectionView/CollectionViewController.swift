//
//  CollectionViewController.swift
//  Oops Coding Challenge
//
//  Created by Justin Schwartz on 4/24/23.
//

import SwiftUI
import UIKit

protocol CardCollectionViewCellDelegate: AnyObject {
  func didSelectCard(cell: CardCollectionViewCell)
}

protocol CollectionViewControllerDelegate: AnyObject {
  func didSelectCardInCollectionViewController(cell: CardCollectionViewCell, movie: Movie, position: CGPoint)
}

class CollectionViewController: UIViewController, UICollectionViewDelegate, CardCollectionViewCellDelegate {
  weak var delegate: CollectionViewControllerDelegate?
  var collectionView: UICollectionView!
  private var dataSource: UICollectionViewDiffableDataSource<Int, Movie>!
  
  let moviesViewModel: MoviesViewModel
  
  let horizontalPadding: CGFloat
  let verticalPadding: CGFloat
  
  let horizontalGridSpacing: CGFloat
  let verticalGridSpacing: CGFloat
  
  init(
    moviesViewModel: MoviesViewModel,
    horizontalPadding: CGFloat = 0,
    verticalPadding: CGFloat = 0,
    horizontalGridSpacing: CGFloat = 0,
    verticalGridSpacing: CGFloat = 0
  ) {
    self.moviesViewModel = moviesViewModel
    self.horizontalPadding = horizontalPadding
    self.verticalPadding = verticalPadding
    self.horizontalGridSpacing = horizontalGridSpacing
    self.verticalGridSpacing = verticalGridSpacing
    
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureCollectionView()
    configureDataSource()
  }
  
  private func configureCollectionView() {
    // item
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .absolute(CardSizing.cardWidth),
      heightDimension: .absolute(CardSizing.cardHeight)
    )
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    
    // group
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .absolute(CardSizing.cardHeight)
    )
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 3)
    group.interItemSpacing = .fixed(horizontalGridSpacing)
    
    // section
    let section = NSCollectionLayoutSection(group: group)
    section.interGroupSpacing = verticalGridSpacing
    section.orthogonalScrollingBehavior = .none
    section.contentInsets = NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)

    // configuration
    let configuration = UICollectionViewCompositionalLayoutConfiguration()
    configuration.scrollDirection = .vertical
    
    // compositional layout
    let layout = UICollectionViewCompositionalLayout(section: section, configuration: configuration)
    
    // collection view
    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    collectionView.backgroundColor = .systemBackground
    
    // register the custom cell
    collectionView.register(CardCollectionViewCell.self, forCellWithReuseIdentifier: CardCollectionViewCell.reuseIdentifier)
    
    // add the collection view to the view hierarchy
    view.addSubview(collectionView)
  }
  
  private func configureDataSource() {
    // configure diffable data source
    dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) { collectionView, indexPath, movie -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.reuseIdentifier, for: indexPath) as! CardCollectionViewCell
      cell.delegate = self
      
      // cell using uihostingconfiguration
      cell.contentConfiguration = UIHostingConfiguration {
        CardView(cardSelected: .constant(false), movie: movie)
          .onTapGesture {
            cell.delegate?.didSelectCard(cell: cell)
          }
          .environmentObject(self.moviesViewModel)
      }
      return cell
    }
    
    // create snapshot and append data from view model
    var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
    snapshot.appendSections([0])
    snapshot.appendItems(moviesViewModel.movies)
    dataSource.apply(snapshot, animatingDifferences: false)
  }
  
  func didSelectCard(cell: CardCollectionViewCell) {
    guard let indexPath = collectionView.indexPath(for: cell),
          let movie = dataSource.itemIdentifier(for: indexPath),
          let superview = collectionView.superview else { return }
    
    let frameInSuperview = cell.contentView.convert(cell.contentView.frame, to: superview)
    
    delegate?.didSelectCardInCollectionViewController(cell: cell, movie: movie, position: frameInSuperview.origin)
  }
}
