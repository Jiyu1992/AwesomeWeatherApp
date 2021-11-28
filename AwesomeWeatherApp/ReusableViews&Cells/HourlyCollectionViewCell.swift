//
//  HourlyCollectionViewCell.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 25/11/21.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var weatherIcon:UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }

    
    
}
