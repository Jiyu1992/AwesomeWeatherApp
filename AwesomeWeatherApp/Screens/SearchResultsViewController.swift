//
//  SearchResultsViewController.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 22/11/21.
//

import UIKit
import CoreData

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectCity(city: Location, shouldAddCity: Bool)
}

class SearchResultsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    typealias DataSource = UITableViewDiffableDataSource<Section, Location>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Location>
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    enum Section {
        case all
    }
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
//    lazy var dataSource = makeDataSource()
    var cities: [Location]? {
        didSet {
            fetchFromCoreData()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var myCities : [MyCity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchFromCoreData()
        self.tableView.reloadData()
//        applySnapshot()
        // Do any additional setup after loading the view.
    }
    
    
//    MARK: - Diffable crushes on start, why?? Fallback on traditional, boring UITableView
//    func applySnapshot(animatingDifferences: Bool = false) {
//        guard let cities = cities else {
//            print("The results where nil, the feck??")
//            return
//        }
//        var snapshot = Snapshot()
//        snapshot.appendSections([.all])
//        snapshot.appendItems(cities)
//        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
//    }
//
//    func makeDataSource() -> DataSource{
//
////        let addBtn = UIButton(type: .contactAdd)
//        let accessoryImageView = UIImageView(image: UIImage(systemName: "plus"))
//        let accessoryLabelView = UILabel()
//        accessoryLabelView.text = "added"
//        accessoryLabelView.textColor = .lightGray
//
//
//        let dataSource = DataSource(
//            tableView: self.tableView,
//            cellProvider: {(tableView, indexPath, city) -> UITableViewCell? in
//
//                let cell = tableView.dequeueReusableCell(
//                  withIdentifier: "SearchResultCell",
//                for: indexPath) as UITableViewCell
//
//                var config = cell.defaultContentConfiguration()
//                config.text = city.name
//                cell.accessoryView = accessoryImageView
//                return cell
//          })
//          return dataSource
//      }
    
    
    func fetchFromCoreData(){
        
         
        guard let managedContext = appDelegate?.managedContext else {return}
         
        let fetchRequest = MyCity.fetchRequest()
         
         //3
        do {
            myCities = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let accessoryImageViewAdd = UIImageView(image: UIImage(systemName: "plus"))
        let accessoryImageViewAlreadyAdded = UIImageView(image: UIImage(systemName: "checkmark"))
        let cell = tableView.dequeueReusableCell(
          withIdentifier: "SearchResultCell",
          for: indexPath) as! SearchResultCell
        
//        var config = cell.defaultContentConfiguration()
        cell.nameLabel.text = cities?[indexPath.row].name
        cell.accessoryView = accessoryImageViewAdd
        if let myCities = myCities, !myCities.isEmpty {
            for city in myCities {
                if city.name == cities?[indexPath.row].name {
                    cell.accessoryView = accessoryImageViewAlreadyAdded
                    break
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedCity = cities?[indexPath.row] else { return }
//        addACity(myCity: selectedCity )
        var shouldAddCity = true
        if let myCities = myCities, !myCities.isEmpty {
            for city in myCities {
                if city.name == cities?[indexPath.row].name {
                    shouldAddCity = false
                    break
                }
            }
        }
        delegate?.didSelectCity(city: selectedCity, shouldAddCity: shouldAddCity)
    }

}
