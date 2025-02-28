//
//  TopSearchView.swift
//  Equity
//
//  Created by ANDELA on 27/02/2025.
//

import UIKit

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
