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
    
    //searchInputViewLeadingConstraint.constant = isHidden ? 0 : (150)
    topSearchViewHeightConstraint.constant = isHidden ? 0 : 50 // Hide/show top search view
    collectionViewHeightConstraint.constant = isHidden ? 0 : 50 // Hide/show collection view
    collectionView.isHidden = isHidden
    topSearchView.isHidden = isHidden

    let newHeaderHeight = isHidden ? 50 : 120 // Adjust to match visible elements
    headerViewHeightConstraint.constant = CGFloat(newHeaderHeight)
    
    UIView.animate(withDuration: 0.0, animations: {
      self.searchInputView.alpha = isHidden ? 1 : 0
      self.layoutIfNeeded()
    })
  }
  
    
    private func setupLayout() {

      headerViewHeightConstraint = heightAnchor.constraint(equalToConstant: 120)

      searchInputViewLeadingConstraint = searchInputView.leadingAnchor.constraint(equalTo: leadingAnchor, constant:10)
      
      topSearchViewHeightConstraint = topSearchView.heightAnchor.constraint(equalToConstant: 50) // Default height
      collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 50) // Default height

        NSLayoutConstraint.activate([
          headerViewHeightConstraint,
            topSearchView.topAnchor.constraint(equalTo: topAnchor),
            topSearchView.leadingAnchor.constraint(equalTo: leadingAnchor),
            topSearchView.trailingAnchor.constraint(equalTo: trailingAnchor),
            topSearchViewHeightConstraint,
          
          searchInputViewLeadingConstraint,
          searchInputView.topAnchor.constraint(equalTo: topAnchor),
          searchInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          searchInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            searchInputView.heightAnchor.constraint(equalToConstant: 50),
            
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



class TopSearchView: UIView {
    var onSearchTapped: (() -> Void)?
    private let searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
      button.tintColor = UIColor.dynamicColor(for: .text)
        return button
    }()
    
    private let roundView: UIView = {
        let roundedView = UIView()
        roundedView.translatesAutoresizingMaskIntoConstraints = false
        roundedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        roundedView.layer.cornerRadius = 18
        roundedView.clipsToBounds = true
        return roundedView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Top 100"
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupLayout()
        setupActions()
    }
    
    func setupView() {
        addSubview(headerLabel)
        addSubview(roundView)
        roundView.addSubview(searchButton)
    }
    
  func setupLayout() {
      NSLayoutConstraint.activate([
          // RoundView (Search Button Container)
          roundView.widthAnchor.constraint(equalToConstant: 36),
          roundView.heightAnchor.constraint(equalToConstant: 36),
          roundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
         roundView.centerYAnchor.constraint(equalTo: centerYAnchor),
          // Center the search button inside the rounded view
          searchButton.centerXAnchor.constraint(equalTo: roundView.centerXAnchor),
          searchButton.centerYAnchor.constraint(equalTo: roundView.centerYAnchor),
          
          // Header Label (Centered)
          headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
          headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      ])
  }
  
  private func setupActions() {
    searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
  }
  
  @objc private func searchButtonTapped() {
    onSearchTapped?()
  }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SearchFieldView: UIView {
  var cancelAction: (() -> Void)?
  let searchTextField:UITextField = {
    let searchTextField = UITextField()
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    searchTextField.placeholder = "Search"
    searchTextField.borderStyle = .none
    return searchTextField
  }()
  
  private let cancelButton:UIButton = {
    let cancelButton = UIButton(type: .system)
    cancelButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.tintColor = UIColor.dynamicColor(for: .text)
    return cancelButton
  }()
  
  private let stackView:UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  override init(frame: CGRect) {
      super.init(frame: frame)
    // Add the text field to the view
    addSubview(stackView)
    stackView.addArrangedSubview(cancelButton)
    stackView.addArrangedSubview(searchTextField)
    
    // Set constraints for the text field
    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
      stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
      cancelButton.widthAnchor.constraint(equalToConstant: 66),
      cancelButton.heightAnchor.constraint(equalToConstant: 44),
      searchTextField.widthAnchor.constraint(equalToConstant: 350),
      searchTextField.heightAnchor.constraint(equalToConstant: 44)
    ])
    setupActions()
  }
  
  private func setupActions() {
    cancelButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
  }
  
  @objc private func searchButtonTapped() {
    cancelAction?()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct FilterOption {
  var title: String
  var imageTitle: String?
}
