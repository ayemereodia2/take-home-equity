//
//  CoinViewCell.swift
//  Equity
//
//  Created by ANDELA on 25/02/2025.
//

import UIKit

class CoinViewCell: UITableViewCell {
    static let identifier = "CoinViewCell"
    private var imageLoadTask: URLSessionDataTask?

    let circleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.layer.cornerRadius = view.bounds.height / 2
      view.translatesAutoresizingMaskIntoConstraints = false
      view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
  private let twentyFourHourPerformance: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 6
    button.setTitleColor(UIColor.dynamicColor(for:.text), for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    button.tintColor = UIColor.secondaryLabel
    button.backgroundColor = UIColor.green.withAlphaComponent(0.3)
    return button
  }()
  
  private let currentPrice:UILabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      label.textColor = UIColor.gray
      return label
  }()
    
  private let cryptoIcon:UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "brain.head.profile")
        return icon
    }()
    
    private let cryptoName:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.dynamicColor(for: .text)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cryptoShortName:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let transactionDescriptionLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let leftStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
      stackView.alignment = .trailing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let topCircleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
      selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        addSubview(topCircleStackView)
        headerStackView.addArrangedSubview(cryptoName)
        headerStackView.addArrangedSubview(cryptoShortName)
        leftStackView.addArrangedSubview(currentPrice)
        leftStackView.addArrangedSubview(twentyFourHourPerformance)
        circleView.addSubview(cryptoIcon)
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(leftStackView)
        topCircleStackView.addArrangedSubview(circleView)
        topCircleStackView.addArrangedSubview(stackView)

        NSLayoutConstraint.activate([
          topCircleStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
          topCircleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
          topCircleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
          topCircleStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            circleView.heightAnchor.constraint(equalToConstant: 40),
            circleView.widthAnchor.constraint(equalToConstant: 40),
            cryptoIcon.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            cryptoIcon.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
          twentyFourHourPerformance.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
  func configureCell(model: CryptoItem) {
    cryptoName.text = model.name
    cryptoShortName.text = model.symbol
    currentPrice.text = "CA$\(model.price)"
    
  
    let performance = Double.random(in: -5...5) // Mock value
    let isPositive = performance >= 0
    twentyFourHourPerformance.setTitle(String(format: "%.2f%%", performance), for: .normal)
    twentyFourHourPerformance.setTitleColor(isPositive ? .green : .red, for: .normal)
    twentyFourHourPerformance.backgroundColor = (isPositive ? UIColor.green : UIColor.red).withAlphaComponent(0.3)
    
    // Load icon image if URL is provided
    if let url = URL(string: "https://cdn.coinranking.com/iImvX5-OG/5426.png") {
      imageLoadTask = ImageLoader.shared.loadImage(from: url) { [weak self] image in
        guard let self = self else { return }
        self.cryptoIcon.image = image ?? UIImage(systemName: "exclamationmark.triangle")
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    // Cancel any ongoing image load task to prevent wrong image assignment
    ImageLoader.shared.cancel(task: imageLoadTask)
    imageLoadTask = nil
    cryptoIcon.image = UIImage(systemName: "bitcoinsign.circle") // Reset to placeholder
  }
}
