//
//  HeaderView.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit

class HeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  private var searchInputViewLeadingConstraint: NSLayoutConstraint!
  private var topSearchViewHeightConstraint: NSLayoutConstraint!
  private var collectionViewHeightConstraint: NSLayoutConstraint!
  private var headerViewHeightConstraint: NSLayoutConstraint!
  var filterAction: (() -> Void)?
  
  private let topSearchView:TopSearchView = {
    let topSearchView = TopSearchView()
    topSearchView.translatesAutoresizingMaskIntoConstraints = false
    return topSearchView
  }()
  
  private let searchInputView:SearchFieldView = {
    let searchButtonView = SearchFieldView()
    searchButtonView.translatesAutoresizingMaskIntoConstraints = false
    searchButtonView.alpha = 0
    searchButtonView.layer.cornerRadius = 20
    searchButtonView.clipsToBounds = true
    searchButtonView.layer.borderWidth = 1
    searchButtonView.layer.borderColor = UIColor.dynamicCGColor(for: .border)
    return searchButtonView
  }()
  
  // TODO: pass data from view model
  private let filterOptions = [
    FilterOption(title: "", imageTitle: "slider.horizontal.2.square"),
    FilterOption(title: "All assets"),
    FilterOption(title: "Market cap")
  ]
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.sectionInset = UIEdgeInsets(top: 2, left: 40, bottom: 2, right: 100)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.isScrollEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(FilterButtonCell.self, forCellWithReuseIdentifier: "FilterButtonCell")
    collectionView.isHidden = false
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupLayout()
  }
  
  private func setupView() {
    addSubview(topSearchView)
    addSubview(collectionView)
    addSubview(searchInputView)
    
    // add search Input view
    topSearchView.onSearchTapped = { [weak self] in
      self?.toggleSearchInputView()
    }
    
    searchInputView.cancelAction = { [weak self] in
      self?.toggleSearchInputView()
    }
  }
  
  private func toggleSearchInputView() {
    let isHidden = searchInputView.alpha == 0
  
    collectionView.isHidden = isHidden
    topSearchView.isHidden = isHidden

    let newHeaderHeight = isHidden ? 50 : 120
    headerViewHeightConstraint.constant = CGFloat(newHeaderHeight)
    
    UIView.animate(withDuration: 0.0, animations: {
      self.searchInputView.alpha = isHidden ? 1 : 0
      self.layoutIfNeeded()
    })
  }
  
  
  private func setupLayout() {
    
    headerViewHeightConstraint = heightAnchor.constraint(equalToConstant: 120)

    topSearchViewHeightConstraint = topSearchView.heightAnchor.constraint(equalToConstant: 50)
    collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 50)
    
    NSLayoutConstraint.activate([
      headerViewHeightConstraint,
      topSearchView.topAnchor.constraint(equalTo: topAnchor),
      topSearchView.leadingAnchor.constraint(equalTo: leadingAnchor),
      topSearchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
      searchInputView.topAnchor.constraint(equalTo: topAnchor),
      searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:10),
      searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
      searchInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
  
      collectionView.topAnchor.constraint(equalTo: topSearchView.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
      collectionViewHeightConstraint,
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - CollectionView DataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filterOptions.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterButtonCell", for: indexPath) as! FilterButtonCell
    cell.configure(with: filterOptions[indexPath.item])
    switch indexPath.row {
    case 0:
      cell.onFilterTapped = { [weak self] in
        self?.filterAction?()
      }
    default:
      debugPrint("Pass")
    }
    
    return cell
  }
  
  // MARK: - CollectionView Flow Layout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    switch indexPath.row {
    case 0:
      return CGSize(width: 50, height: 40)
    default:
      return CGSize(width: 100, height: 40)
    }
  }
  
}


struct FilterOption {
  var title: String
  var imageTitle: String?
}
