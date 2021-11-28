//
//  DayTableViewCell.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 27/11/21.
//

import UIKit

class DayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
