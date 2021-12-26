//
//  MapController.swift
//  fefuactivity
//
//  Created by Mike Litvin on 21.11.2021.
//

import UIKit
import CoreLocation
import MapKit

private let image = UIImage(named: "cellViewImage")

private let cellTypeData: [collectionCell] =
[
    collectionCell(name: "Велосипед", img: image ?? UIImage(), type: "На велике"),
    collectionCell(name: "Бег", img: image ?? UIImage(), type: "Бежим")
]

private var selectedType: String?

class MapController: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var activityView: UIView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var typeOfActivityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
        
    private var isPaused: Bool = true
    private let coreDataContainer = CoreDataContainer.instance
    private var previousRouteSegment: MKPolyline?
    private var currentDuration: TimeInterval = TimeInterval()
    private var startValueForTimer: Date?
    private var timer: Timer?
        
    private var activityDistance: CLLocationDistance = CLLocationDistance()
    private var activityDate: Date?
    private var activityDuration: TimeInterval = TimeInterval()
    private var activityType: String?
    
    @objc func timerUpdater() {
        let time = Date().timeIntervalSince(startValueForTimer!)
            
        currentDuration = time
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.zeroFormattingBehavior = .pad
            
        timeLabel.text = timeFormatter.string(from: time + activityDuration)
    }
        
    private var timeFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
        
    private var timeFormatterShort: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
        
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        userLocationsHistory = []
        userLocation = nil
                
        if !isPaused {
            pauseButton.setImage(UIImage(named: "play"), for: .normal)
                    
            activityDuration += currentDuration
            currentDuration = TimeInterval()
            timer?.invalidate()
                    
            locationManager.stopUpdatingLocation()
        } else {
            pauseButton.setImage(UIImage(named: "pause"), for: .normal)
                    
            startValueForTimer = Date()
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdater), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
        }
                
        isPaused = !isPaused
                
        activityDate = Date()
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        locationManager.stopUpdatingLocation()
                
        let context = coreDataContainer.context
        let activity = ActivityDataModel(context: context)
                
        activityDuration += currentDuration
        timer?.invalidate()
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let activityStartTime = dateFormatter.string(from: activityDate!)
        let activityEndTime = dateFormatter.string(from: activityDate! + activityDuration)
                
        activity.date = activityDate
        activity.distance = activityDistance
        activity.duration = activityDuration
        activity.endTime = activityEndTime
        activity.startTime = activityStartTime
        activity.type = activityType
                
        coreDataContainer.saveContext()
                
        let logView = ActivitiesController(nibName: "ActivitiesController", bundle: nil)
        navigationController?.pushViewController(logView, animated: true)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        startView.isHidden = true
        activityView.isHidden = false
        isPaused = false
    }
    
    let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        return manager
    }()
    
    var userLocation: CLLocation? {
        didSet {
            guard let userLocation = userLocation else {
                return
            }
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 500,longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            if oldValue != nil { activityDistance += userLocation.distance(from: oldValue!)}
            userLocationsHistory.append(userLocation)
            distanceLabel.text = String(format: "%.2f км", activityDistance / 1000)
        }
    }
    
    fileprivate var userLocationsHistory: [CLLocation] = [] {
        didSet {
            let coordinates = userLocationsHistory.map { $0.coordinate}
            let route = MKPolyline(coordinates: coordinates, count: coordinates.count)
            route.title = "Ваш маршрут"
            
            mapView.addOverlay(route)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityView.isHidden = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.title = "Новая активность"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        typeOfActivityLabel.text = "На велике"
        
        let nib = UINib(nibName: "CollectionViewCellController", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "СollectionViewCellController")
    }
}

extension MapController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else{
            return
        }
        print("Координаты устройства:", currentLocation.coordinate)
        userLocation = currentLocation
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            
            let render = MKPolylineRenderer(polyline: polyline)
            
            render.fillColor = UIColor.blue
            render.strokeColor = UIColor.blue
            render.lineWidth = 5
            
            return render
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let userLocationIdentifior = "ic_user_location"
        if let annotation = annotation as? MKUserLocation {
            let dequedView = mapView.dequeueReusableAnnotationView(withIdentifier: userLocationIdentifior)
            let view = dequedView ??  MKAnnotationView(annotation: annotation, reuseIdentifier: userLocationIdentifior)
            view.image = UIImage(named: "ic_user_location")
            return view
        }
        return nil
    }
}

extension MapController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCellController{
            cell.customCell.layer.borderWidth = 3

            selectedType = cell.cellType
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCellController {
                    cell.customCell.layer.borderWidth = 0
                }
    }
}

extension MapController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellTypeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellTypeData[indexPath.row]
        let dequeuedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellController", for: indexPath)
        
        guard let upcastedCell = dequeuedCell as? CollectionViewCellController else{
            return UICollectionViewCell()
        }
        upcastedCell.setCellStats(cell)
        
        return upcastedCell
    }
}
