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
    
    // MARK: - Subviews
    let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20 // Half of height/width for circle
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private let twentyFourHourPerformance: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 6
        button.setTitleColor(UIColor.dynamicColor(for: .text), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.tintColor = UIColor.secondaryLabel
        button.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        return button
    }()
    
    private let currentPrice: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = UIColor.dynamicColor(for: .text)
        return label
    }()
    
    private let cryptoIcon: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(systemName: "photo")
        return icon
    }()
    
    private let cryptoName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = UIColor.dynamicColor(for: .text)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cryptoShortName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.lightGray.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        contentView.addSubview(stackView) // Use contentView for UITableViewCell
        headerStackView.addArrangedSubview(cryptoName)
        headerStackView.addArrangedSubview(cryptoShortName)
        leftStackView.addArrangedSubview(currentPrice)
        leftStackView.addArrangedSubview(twentyFourHourPerformance)
        circleView.addSubview(cryptoIcon)
        stackView.addArrangedSubview(circleView)
        stackView.addArrangedSubview(headerStackView)
        stackView.addArrangedSubview(leftStackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            circleView.widthAnchor.constraint(equalToConstant: 40),
            circleView.heightAnchor.constraint(equalToConstant: 40),
            cryptoIcon.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            cryptoIcon.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            cryptoIcon.widthAnchor.constraint(equalToConstant: 30),
            cryptoIcon.heightAnchor.constraint(equalToConstant: 30),
            twentyFourHourPerformance.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    func configureCell(model: CryptoItem) {
        cryptoName.text = model.name
        cryptoShortName.text = model.symbol
        currentPrice.text = MoneyFormat.formatPrice(model.price, currencyCode: .cad)
        
        let isPositive = Double(model.change) ?? 0 >= 0
        twentyFourHourPerformance.setTitle(String(format: "%.2f%%", Double(model.change) ?? 0), for: .normal)
        twentyFourHourPerformance.setTitleColor(isPositive ? .green : .red, for: .normal)
        twentyFourHourPerformance.backgroundColor = (isPositive ? UIColor.green : UIColor.red).withAlphaComponent(0.3)
        
        if let strUrl = model.iconUrl, let url = URL(string: strUrl) {
            imageLoadTask = ImageLoader.shared.loadImage(from: url) { [weak self] image in
                guard let self = self else { return }
                self.cryptoIcon.image = image ?? UIImage(systemName: "bitcoinsign.arrow.circlepath")
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ImageLoader.shared.cancel(task: imageLoadTask)
        imageLoadTask = nil
        cryptoIcon.image = UIImage(systemName: "bitcoinsign.circle")
    }
}
