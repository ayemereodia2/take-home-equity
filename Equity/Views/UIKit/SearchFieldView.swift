//
//  SearchFieldView.swift
//  Equity
//
//  Created by ANDELA on 27/02/2025.
//

import UIKit

class SearchFieldView: UIView {
  var cancelAction: (() -> Void)?
  let searchTextField:UITextField = {
    let searchTextField = UITextField()
    searchTextField.translatesAutoresizingMaskIntoConstraints = false
    searchTextField.placeholder = "Search"
    searchTextField.borderStyle = .none
    searchTextField.backgroundColor = .blue
    return searchTextField
  }()
  
  private let cancelButton:UIButton = {
    let cancelButton = UIButton(type: .system)
    cancelButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.tintColor = UIColor.dynamicColor(for: .text)
    cancelButton.backgroundColor = .red
    return cancelButton
  }()
  
  private let stackView:UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 0
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
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      cancelButton.widthAnchor.constraint(equalToConstant: 66),
      cancelButton.heightAnchor.constraint(equalToConstant: 44),
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
