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
    @IBOutlet weak var mapView: MKMapView!
    
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
            userLocationsHistory.append(userLocation)
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.title = "Новая активность"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Назад", style: .plain, target: nil, action: nil)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        let nib = UINib(nibName: "CollectionViewCellController", bundle: nil)
        
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewCellController")
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
