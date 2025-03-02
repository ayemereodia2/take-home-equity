//
//  HeaderView.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit
class HeaderView: UIView {
    // MARK: - Properties
    weak var delegate: HeaderViewDelegate?
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
      filterManager: FilterCollectionViewManager
    ) {
      self.filterManager = filterManager
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
            self?.toggleSearchInputView()
        }
        
        searchInputView.cancelAction = { [weak self] in
            self?.toggleSearchInputView()
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
    
    // MARK: - Public API
    func setDelegate(_ delegate: HeaderViewDelegate) {
        self.delegate = delegate
        filterManager.delegate = delegate
    }
}

struct FilterOption: Equatable {
    let id: String 
    let title: String
    let imageTitle: String?
    
    static func == (lhs: FilterOption, rhs: FilterOption) -> Bool {
        lhs.id == rhs.id
    }
}

// Protocol for HeaderView actions
protocol HeaderViewDelegate: AnyObject {
    func didTapFilter()
    func didTapAllAssets()
    func didSearch(_ text: String)
    func didCancelSearch()
}

class FilterCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let filterOptions: [FilterOption]
    weak var delegate: HeaderViewDelegate?
    private var selectedFilterId: String?
    
    init(filterOptions: [FilterOption], delegate: HeaderViewDelegate?) {
        self.filterOptions = filterOptions
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filterOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterButtonCell", for: indexPath) as! FilterButtonCell
        let option = filterOptions[indexPath.item]
        cell.configure(with: option)
        let isSelected = option.id == selectedFilterId
        cell.updateBackgroundColor(isSelected: isSelected)
        
        cell.onFilterTapped = { [weak self] in
            guard let self = self else { return }
            self.selectedFilterId = option.id
            collectionView.reloadData() // Update all cells to reflect selection
            switch option.id {
            case "filter": self.delegate?.didTapFilter()
            case "allAssets": self.delegate?.didTapAllAssets()
            default: break
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch filterOptions[indexPath.row].id {
        case "filter": return CGSize(width: 50, height: 40)
        default: return CGSize(width: 100, height: 40)
        }
    }
}
