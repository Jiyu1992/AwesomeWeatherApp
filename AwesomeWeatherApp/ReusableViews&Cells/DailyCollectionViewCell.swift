//
//  DailyCollectionViewCell.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 26/11/21.
//

import UIKit

class DailyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayLabel:UILabel!
    @IBOutlet weak var tempLabel:UILabel!
    @IBOutlet weak var conditionLabel:UILabel!
    @IBOutlet weak var weatherIcon:UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
