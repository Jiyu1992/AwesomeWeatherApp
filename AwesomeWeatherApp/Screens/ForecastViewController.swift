//
//  ForecastViewController.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 27/11/21.
//

import UIKit

class ForecastViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var days: [Forecastday]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        days?.count ?? 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayTableViewCell", for: indexPath) as! DayTableViewCell
        cell.dayLabel.text = days?[indexPath.row].date
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let tableViewCell = cell as? DayTableViewCell else { return }

        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days?[collectionView.tag].hour?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HourlyCollectionViewCell",
       for: indexPath) as! HourlyCollectionViewCell
       
       let hour = days?[collectionView.tag].hour

       cell.timeLabel.text = self.stringToDateToHour(dateString: hour?[indexPath.item].time)
       cell.tempLabel.text = String(format: "%.0f", hour?[indexPath.item].tempC ?? 0.0) + "°C"

       let code = getCodeFromImageUrl(imageUrl: hour?[indexPath.item].condition?.icon)

        if hour?[indexPath.item].isDay == 0 {
           cell.weatherIcon.image = UIImage(named: code)
       }else{
           cell.weatherIcon.image = UIImage(named: "d" + code)
       }
       return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }

}
