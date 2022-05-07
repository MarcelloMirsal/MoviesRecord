//
//  MovieImagesLayout.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 20/04/2022.
//

import UIKit


class MovieImagesLayout {
    
    private let commonSpacing: CGFloat  = 4
    func imagesLayout() -> UICollectionViewCompositionalLayout {
        let headerItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(3/4)))
        
        let doubleItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        
        let doubleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5)), subitem: doubleItem, count: 2)
        doubleGroup.interItemSpacing = .fixed(commonSpacing)
        
        let tripleRowItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1)))
        
        let tripleRowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)), subitem: tripleRowItem, count: 3)
        tripleRowGroup.interItemSpacing = .fixed(commonSpacing)
        
        let wideItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(9/16)))
        
        let mainGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200)), subitems: [headerItem, doubleGroup, wideItem, tripleRowGroup])
        mainGroup.interItemSpacing = .fixed(commonSpacing)
        
        let section = NSCollectionLayoutSection.init(group: mainGroup)
        section.interGroupSpacing = commonSpacing
        return UICollectionViewCompositionalLayout(section: section)
    }
    
}
