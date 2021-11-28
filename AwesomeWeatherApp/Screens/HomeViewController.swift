//
//  ViewController.swift
//  AwesomeWeatherApp
//
//  Created by Lefteris Mantas on 20/11/21.
//

import UIKit
import CoreLocation

protocol MyCitiesVCDelegate {
    func didPickCity(name: String)
}

protocol HomeViewControllerDelegate {
    func footerBtntapped()
}

protocol ModalAddingDelegate {
    func didAddCity(city: Location, shouldAddCity:Bool)
}

class HomeViewController: UIViewController,CLLocationManagerDelegate,UICollectionViewDelegate,MyCitiesVCDelegate, HomeViewControllerDelegate{
    
    enum Section: CaseIterable {
        case hours
        case days
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
    
//    @IBOutlet weak var button: UIButton!
    
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var countryLabel: UILabel!
//    @IBOutlet weak var gradientBG:UIView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let manager = NetworkManager()
    var modalDelegate: ModalAddingDelegate?
    var locationManager: CLLocationManager!
    var geolocatedCity: (Double,Double)? {
        didSet{
            if cityNameFromMyCities.isEmpty {
                let stringCity = (geolocatedCity?.0.string)! + "," + (geolocatedCity?.1.string)!
                locationManager.stopUpdatingLocation()
                getForecast(parameter: stringCity)
            }
        }
    }
    var currentWeather: [Current]?
    var currentCity: [MyCity]?
    var allTheData: ApiResponse?
    var cityNameFromMyCities = ""
    var shouldShowAdd: Bool = false
    var shouldShowCancel: Bool = false
    var bgLayer =  CAGradientLayer()
    lazy var dataSource = makeDataSource()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Welcome"
        setupLocationManager()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pushToMyCitiesCV))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.scrollEdgeAppearance = self.navigationController?.navigationBar.scrollEdgeAppearance
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = configureCollectionLayout()
        
        collectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderReusableView.reuseIdentifier)

        collectionView.register(FooterReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterReusableView.reuseIdentifier)
        
        
        configureSupplementaryView()
//        applySnapshot()

        if !cityNameFromMyCities.isEmpty {
            getForecast(parameter: cityNameFromMyCities)
        }else {
            if geolocatedCity == nil {
                guard let favoriteCity = UserDefaults.standard.string(forKey: "FavoriteCity") else {return}
                getForecast(parameter: favoriteCity)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        bgLayer.frame = view.bounds
    }
    
//  MARK: Setup basic UI elements
    
    func setupUI(currentModel: ApiResponse?){
        
        setGradientBGColor(current: currentModel?.current, bgLayer: bgLayer)
        titleLabel.text = currentModel?.location.name
        
        addBtn.addTarget(self, action: #selector(modalAddTapped), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(modalCancelTapped), for: .touchUpInside)
        
//        if self.isBeingPresented {
//            cancelBtn.isHidden = false
//            addBtn.isHidden = false
//        }
        
        cancelBtn.isHidden = !shouldShowCancel
        addBtn.isHidden = !shouldShowAdd
        
        tempLabel.text = (currentModel?.current?.tempC?.string ?? "-") + "°C"
        tempLabel.text = String(format: "%.0f", currentModel?.current?.tempC as! CVarArg) + "°C"
        conditionLabel.text = currentModel?.current?.condition?.text
        
        let code = self.getCodeFromImageUrl(imageUrl: currentModel?.current?.condition?.icon)
        
        if currentModel?.current?.isDay == 0 {
            weatherIconImageView.image = UIImage(named: code)
        }else{
            weatherIconImageView.image = UIImage(named: "d" + code)
        }
    }
    
    @objc func modalAddTapped() {
        guard let city = allTheData?.location else {return}
        self.modalDelegate?.didAddCity(city: city, shouldAddCity: true)
        
    }
    
    @objc func modalCancelTapped() {
        guard let city = allTheData?.location else {return}
        self.modalDelegate?.didAddCity(city: city, shouldAddCity: false)
        
    }
    
    
//  MARK: Geolocation setting and implementation
    func setupLocationManager(){
        if (CLLocationManager.locationServicesEnabled()) {
           locationManager = CLLocationManager()
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
           locationManager.requestAlwaysAuthorization()
           locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){

        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        geolocatedCity = (center.latitude,center.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        let favoriteCity = UserDefaults.standard.string(forKey: "FavoriteCity")
        
        switch status {
          case .restricted, .denied:
            if favoriteCity == nil || favoriteCity == "" {
                pushToMyCitiesCV()
            }
            break
                
          case .authorizedWhenInUse:
             print("The user is kind and good :P ")
            break
                
          case .authorizedAlways:
            print("The user is most generous")
            break
                
          case .notDetermined:
            if favoriteCity == nil || favoriteCity == "" {
                pushToMyCitiesCV()
            }
            break
        }
    }
    
    
//  MARK: Diffable datasource and snapshot implementation
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: {
                (collectionView, indexPath, item) -> UICollectionViewCell? in
                
                if let hour = item as? Hour {
                    let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: "HourlyCollectionViewCell",
                    for: indexPath) as? HourlyCollectionViewCell
                    
                    cell?.timeLabel.text = self.stringToDateToHour(dateString: hour.time)
                    cell?.tempLabel.text = String(format: "%.0f", hour.tempC ?? 0.0) + "°C"
                    
                    let code = self.getCodeFromImageUrl(imageUrl: hour.condition?.icon)
                    
                    if hour.isDay == 0 {
                        cell?.weatherIcon.image = UIImage(named: code)
                    }else{
                        cell?.weatherIcon.image = UIImage(named: "d" + code)
                    }
                    return cell
                }
                
                if let day = item as? Forecastday {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyCollectionViewCell", for: indexPath) as? DailyCollectionViewCell
                    cell?.dayLabel.text = day.date
                    let maxTepm = String(format: "%.0f", day.day?.maxtempC ?? 0.0) + "°C/"
                    let minTemp = String(format: "%.0f", day.day?.mintempC ?? 0.0) + "°C"
                    cell?.tempLabel.text = maxTepm + minTemp
                    let code = self.getCodeFromImageUrl(imageUrl: day.day?.condition?.icon)
                    cell?.weatherIcon.image = UIImage(named: code)
                    cell?.conditionLabel.text = day.day?.condition?.text
                    return cell
                }
                return UICollectionViewCell()
                
        })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = false) {
        
        var snapshot = Snapshot()
        snapshot.appendSections([.hours])
        snapshot.appendSections([.days])
        
//      filter all the past hours
        if let items = allTheData?.forecast?.forecastday?[0].hour{
//            snapshot.appendSections([.hours])
            var futureHours = [Hour]()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let calendar = Calendar.current
            for item in items {
                let date = dateFormatter.date(from: item.time!)
                if date ?? Date(timeIntervalSinceNow: 1) >= calendar.date(byAdding: .minute, value: -30, to: Date())! {
                    futureHours.append(item)
                }
            }
//            snapshot.appendSections([.hours])
            snapshot.appendItems(items, toSection: .hours)
        }else {
            snapshot.appendItems([])
        }
        
        if let items = allTheData?.forecast?.forecastday{
//            snapshot.appendSections([.days])
            snapshot.appendItems(items, toSection: .days)
        }
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
//  MARK: Api related methods
    func getForecast(parameter: String){
        manager.fetchGeneric(parameter: parameter, typeOfCall: .forecast){ data, error in
            guard let data = data else {
//              Maybe add a no network view?
                return
            }
            self.allTheData = data
            UserDefaults.standard.setValue(data.location.name, forKey: "FavoriteCity")
            DispatchQueue.main.async {
                self.setupUI(currentModel: data)
                self.applySnapshot()
            }
        }
    }
    
//  MARK: Custom Protocol Conformance
    func didPickCity(name: String) {
        getForecast(parameter: name)
    }
    
    func footerBtntapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forecastCV = storyboard.instantiateViewController(withIdentifier: "ForecastViewController") as! ForecastViewController
        forecastCV.days = allTheData?.forecast?.forecastday
//        forecastCV.title = allTheData?.location.name
//        myCitiesCV.delegate = self
        self.navigationController?.pushViewController(forecastCV, animated: true)
    }
    
// MARK: Other helper funcs
    
    @objc func pushToMyCitiesCV(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myCitiesCV = storyboard.instantiateViewController(withIdentifier: "MyCitiesViewController") as! MyCitiesViewController
        myCitiesCV.delegate = self
        self.navigationController?.pushViewController(myCitiesCV, animated: true)
    }
}


// MARK: CollectionView layout code
extension HomeViewController {
    
    func configureSupplementaryView() {
        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            let title: String = {
               
                switch section{
                case .hours:
                    return "Today - Hourly"
                case .days:
                    return "3-Day Forecast"
                }
            }()
            
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                guard let headerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: HeaderReusableView.reuseIdentifier,
                    for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
                
                headerView.setTitle(title: title)
                headerView.titleLabel.textColor = .white
                
                return headerView
            default:
                guard let footerView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    withReuseIdentifier: FooterReusableView.reuseIdentifier,
                    for: indexPath) as? FooterReusableView else { return UICollectionReusableView() }
                footerView.delegate = self
                footerView.isHidden = section == .hours ? true : false
                return footerView
            }
        }
    }
    
    func configureCollectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            
            
            
            let sections = self.dataSource.snapshot().sectionIdentifiers
            
            switch sections[sectionIndex]{
            case .hours:
                return self.getCellSectionLayout(section: Section.hours)
            case .days:
                return self.getCellSectionLayout(section: Section.days)
            }
        }
//      we have to register decorating views upon a NSCollectionLayoutSection obj. They are not available before initialising a layout for our collection view
        layout.register(BackgoundReusableView.self, forDecorationViewOfKind: BackgoundReusableView.reuseIdentifier)
        
        return layout
    }
    
    func getCellSectionLayout(section:Section) -> NSCollectionLayoutSection {
        var group: NSCollectionLayoutGroup!
        var sectionLayout: NSCollectionLayoutSection!
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        switch section {
        case .hours:
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/5),
                heightDimension: .fractionalHeight(1/4))
            group = .horizontal(layoutSize: groupSize, subitems: [item])
            sectionLayout = .init(group: group)
            sectionLayout.orthogonalScrollingBehavior = .continuous
            sectionLayout.interGroupSpacing = 0
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            
        case .days:
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/12))
            group = .vertical(layoutSize: groupSize, subitem: item, count: 1)
            sectionLayout = .init(group: group)
            sectionLayout.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: BackgoundReusableView.reuseIdentifier)]
            sectionLayout.interGroupSpacing = 0
            sectionLayout.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        }
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .estimated(50))
                
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(50))
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom)
        
        sectionLayout.boundarySupplementaryItems = [headerSupplementary, sectionFooter]
        
        return sectionLayout
        
        
    }
    
}
