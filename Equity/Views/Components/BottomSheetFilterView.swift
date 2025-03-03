//
//  BottomSheetFilterView.swift
//  Equity
//
//  Created by ANDELA on 26/02/2025.
//

import UIKit

class BottomSheetFilterView: UITableViewCell {
  static let identifier = "FilterTableViewCell"
  
  private let filterLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  private let checkbox: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .systemBlue
    return imageView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.addSubview(filterLabel)
    contentView.addSubview(checkbox)
    
    NSLayoutConstraint.activate([
      filterLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      filterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      filterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      checkbox.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      checkbox.widthAnchor.constraint(equalToConstant: 24),
      checkbox.heightAnchor.constraint(equalToConstant: 24),
      filterLabel.trailingAnchor.constraint(equalTo: checkbox.leadingAnchor, constant: -10)
    ])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(with text: String, isSelected: Bool) {
    filterLabel.text = text
    checkbox.image = UIImage(systemName: isSelected ? "checkmark.square.fill" : "square")
  }
}
