//
//  FilterCollectionViewManager.swift
//  Equity
//
//  Created by ANDELA on 02/03/2025.
//

import UIKit

class FilterCollectionViewManager: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private let filterOptions: [FilterOption]
    weak var delegate: HeaderViewDelegate?
    private var selectedFilterId: String?
    
    init(filterOptions: [FilterOption]) {
        self.filterOptions = filterOptions
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
            collectionView.reloadData()
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
