//
//  HeaderView.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit
import Combine

class HeaderView: UIView {
    // MARK: - Properties
    weak var delegate: HeaderViewDelegate?
    private var viewModel: HeaderViewModel
    private var searchInputViewLeadingConstraint: NSLayoutConstraint!
    private var topSearchViewHeightConstraint: NSLayoutConstraint!
    private var collectionViewHeightConstraint: NSLayoutConstraint!
    private var headerViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Subviews
    private let topSearchView: TopSearchView = {
        let view = TopSearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchInputView: SearchFieldView = {
        let view = SearchFieldView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.dynamicCGColor(for: .border)
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 2, left: 40, bottom: 2, right: 100)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FilterButtonCell.self, forCellWithReuseIdentifier: "FilterButtonCell")
        return collectionView
    }()
    
    private let filterManager: FilterCollectionViewManager
    
    // MARK: - Initialization
    init(
      filterManager: FilterCollectionViewManager,
      viewModel: HeaderViewModel = HeaderViewModel()
    ) {
      self.filterManager = filterManager
      self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        addSubview(topSearchView)
        addSubview(collectionView)
        addSubview(searchInputView)
        
        collectionView.delegate = filterManager
        collectionView.dataSource = filterManager
        
        topSearchView.onSearchTapped = { [weak self] in
          self?.viewModel.toggleSearch()
        }
        
        searchInputView.cancelAction = { [weak self] in
            self?.viewModel.toggleSearch()
            self?.delegate?.didCancelSearch()
        }
        
        searchInputView.searchAction = { [weak self] text in
            self?.delegate?.didSearch(text)
        }
    }
    
    private func toggleSearchInputView() {
        let isHidden = searchInputView.alpha == 0
        collectionView.isHidden = isHidden
        topSearchView.isHidden = isHidden
        
        headerViewHeightConstraint.constant = isHidden ? 50 : 120
        
        UIView.animate(withDuration: 0.3) {
            self.searchInputView.alpha = isHidden ? 1 : 0
            self.layoutIfNeeded()
        }
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
            topSearchViewHeightConstraint,
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            searchInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            collectionView.topAnchor.constraint(equalTo: topSearchView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionViewHeightConstraint,
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    
    func setDelegate(_ delegate: HeaderViewDelegate) {
        self.delegate = delegate
        filterManager.delegate = delegate
    }
}


protocol HeaderViewDelegate: AnyObject {
    func didTapFilter()
    func didTapAllAssets()
    func didSearch(_ text: String)
    func didCancelSearch()
}

