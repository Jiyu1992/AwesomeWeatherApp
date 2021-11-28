//
//  MyCitiesViewController.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 21/11/21.
//

import UIKit
import CoreData

class MyCitiesViewController: UIViewController, UISearchResultsUpdating, UICollectionViewDelegate, SearchResultsViewControllerDelegate, ModalAddingDelegate{
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    enum Section {
        case all
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, MyCity>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, MyCity>
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let manager = NetworkManager()
    var searchResultVC: SearchResultsViewController!
    var myCities = [MyCity]()
    var delegate: MyCitiesVCDelegate?
    lazy var dataSource = makeDataSource()
   
    
    
    
    private var searchController: UISearchController!
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering : Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var config = UICollectionLayoutListConfiguration(appearance: .sidebarPlain)
        
        config.trailingSwipeActionsConfigurationProvider = { [weak self] indexPath in
            
            let delete = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
                self?.delete(at: indexPath)
                completion(true)
            }
            let swipe = UISwipeActionsConfiguration(actions: [delete])
            return swipe
        }
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
        fetchFromCoreData()
        configureSearchController()
        applySnapshot()

        // Do any additional setup after loading the view.
    }
    
//  MARK: Fetching from core data
    func fetchFromCoreData(){
         
        guard let managedContext = appDelegate?.managedContext else{return}
         
        let fetchRequest = MyCity.fetchRequest()
         
        do {
            myCities = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
//  MARK: Datasource associated code
    func delete(at ip: IndexPath) {
        guard let managedContext = appDelegate?.managedContext else{return}
        var snapshot = self.dataSource.snapshot()
        if let id = self.dataSource.itemIdentifier(for: ip) {
//          show the change immidiatelly
            snapshot.deleteItems([id])
            managedContext.delete(id)
        }
//      secure the change by changing the datasource array and informing the snapshot
        fetchFromCoreData()
        applySnapshot()
//        self.dataSource.apply(snapshot)
    }
    
    
    func applySnapshot(animatingDifferences: Bool = false) {

      var snapshot = Snapshot()
      snapshot.appendSections([.all])
      snapshot.appendItems(myCities)
      dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: {
                (collectionView, indexPath, city) -> UICollectionViewCell? in
                
                let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MyCitiesCollectionViewCell",
                for: indexPath) as? MyCitiesCollectionViewCell
                
                let fullName = city.value(forKey: "name") as? String
                
                var config = UIListContentConfiguration.cell()

                config.text = String(fullName?.split(separator: ",")[0] ?? "")
                cell?.contentConfiguration = config
                
                return cell
        })
        return dataSource
    }
    
//  MARK: Search controller config and functionality
    
    func configureSearchController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        searchResultVC = storyBoard.instantiateViewController(withIdentifier: "SearchResultsViewController") as? SearchResultsViewController
        searchResultVC.delegate = self
        searchController = UISearchController(searchResultsController: searchResultVC)
        self.definesPresentationContext = true
        searchController.showsSearchResultsController = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Manage your cities"
//        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        searchController.definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let term = searchBar.text, !searchBar.text!.isEmpty{
            searchWithTerm(term: term)
        }
        
    }
    
    func searchWithTerm(term: String) {
        if isFiltering {
            manager.fetchSearch(parameter: term){cities,error in
                guard let _ = cities else {return}
                self.searchResultVC.cities = cities
            }
        }
    }
    
//  MARK: -BONUS: Try to automate the coreData -> Swift Struct mapping
    
    func addACity(myCity: Location) {
        
        guard let managedContext = appDelegate?.managedContext else{return}
        let entity = MyCity.entity()
          
        let coreDataCity = MyCity.init(entity: entity, insertInto: managedContext)
        coreDataCity.name = myCity.name ?? ""
        coreDataCity.region = myCity.region
        coreDataCity.lat = myCity.lat ?? 0.0
        coreDataCity.lon = myCity.lon ?? 0.0
        coreDataCity.country = myCity.country
        coreDataCity.localtimeEpoch = myCity.localtimeEpoch ?? 0
        coreDataCity.tzID = myCity.tzID
        
        do {
            try managedContext.save()
            myCities.append(coreDataCity)
          } catch let error as NSError {
              fatalError("Could not save. \(error), \(error.userInfo)")
          }
    }
        
//  MARK: - protocol conformance
    func didSelectCity(city: Location, shouldAddCity: Bool) {
        searchController.isActive = false
//      empty the datasource of the searchController else leave the last search up
        searchResultVC.cities = []
        
        pushToHome(withCity: city, modaly: true, shouldAddCity: shouldAddCity)
    }
    
    func didAddCity(city: Location, shouldAddCity: Bool) {
        if shouldAddCity {
            addACity(myCity: city)
        }
        applySnapshot()
        dismiss(animated: true, completion: nil)
        
    }
//   MARK: Helpers
    func pushToHome(withCity: Location, modaly: Bool, shouldAddCity: Bool){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeVC.cityNameFromMyCities = withCity.name!
        homeVC.modalDelegate = self
        if modaly{
            homeVC.shouldShowAdd = shouldAddCity
            homeVC.shouldShowCancel = true
            present(homeVC, animated: true, completion: nil)
        }else{
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = self.dataSource.itemIdentifier(for: indexPath)
        delegate?.didPickCity(name: selectedItem?.name ?? "")
        self.navigationController?.popViewController(animated: true)
    }

}
