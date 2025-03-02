//
//  FilterButtonCell.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit

class FilterButtonCell: UICollectionViewCell {
  var onFilterTapped: (() -> Void)?
  private let button: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 20
    button.setTitleColor(UIColor.dynamicColor(for: .text), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    button.tintColor = UIColor.dynamicColor(for: .text)
    button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    contentView.addSubview(button)
    setupActions()
    NSLayoutConstraint.activate([
      button.topAnchor.constraint(equalTo: contentView.topAnchor),
      button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    ])
  }
  
  func configure(with option:FilterOption) {
    button.setTitle(option.title, for: .normal)
    button.setImage(UIImage(systemName: option.imageTitle ?? ""), for: .normal)
    button.tintColor = UIColor.dynamicColor(for: .text)
  }
  
  private func setupActions() {
    button.addTarget(self, action: #selector(filterTapped), for: .touchUpInside)
  }
  
  @objc private func filterTapped() {
    onFilterTapped?()
  }
  
  func updateBackgroundColor(isSelected: Bool) {
    button.backgroundColor = isSelected ? UIColor.dynamicColor(for: .text) : UIColor.lightGray.withAlphaComponent(0.3)
    button.setTitleColor(isSelected ? .black : UIColor.dynamicColor(for: .text), for: .normal)
    button.tintColor = isSelected ? .black : UIColor.dynamicColor(for: .text)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
