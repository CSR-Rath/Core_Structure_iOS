import UIKit
import GoogleMaps
import CoreLocation

// MARK: - Model
struct Location {
    let title: String
    let snippet: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

// MARK: - View Controller
class GoogleMapsViewController: BaseUIViewConroller {
    
    private var mapView = GMSMapView()
    private var markers: [GMSMarker] = []
    private var currentLocationMarker: GMSMarker?
    private var hasCenteredToUser = false
    
    private let locations: [Location] = [
        Location(title: "Phnom Penh", snippet: "Capital City", latitude: 11.5564, longitude: 104.9282),
        Location(title: "Siem Reap", snippet: "Angkor Wat", latitude: 13.3611, longitude: 103.8592),
        Location(title: "Sihanoukville", snippet: "Coastal City", latitude: 10.6271, longitude: 103.5221)
    ]
    
    lazy var btnCurrentLocation: BaseUIButton = {
        let btn = BaseUIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 30
        btn.buttonHeight = 60
        btn.addTarget(self, action: #selector(actionCurrentLocation), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupGoogleMap()
        
        LocationManager.shared.getCurrentLocation { location in
            if let location = location{
                self.zoomToLocation(location)
            }
        }
    }
    
    private func setupGoogleMap() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = false
        mapView.delegate = self
        
        view.addSubview(mapView)
        view.addSubview(btnCurrentLocation)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: 0),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            btnCurrentLocation.widthAnchor.constraint(equalToConstant: 60),
            btnCurrentLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            btnCurrentLocation.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        ])
        
        addMarkers()
    }
    
    private func addMarkers() {
        for (i, e) in locations.enumerated() {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            imageView.layer.cornerRadius = 20
            imageView.layer.borderWidth = 3
            imageView.layer.borderColor = UIColor.white.cgColor
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.image = UIImage(named: "imgRoom")
            
            let marker = GMSMarker()
            marker.iconView = imageView
            marker.position = CLLocationCoordinate2D(latitude: e.latitude, longitude: e.longitude)
            marker.title = e.title
            marker.snippet = e.snippet
            marker.zIndex = Int32(i)
            marker.map = mapView
            
            markers.append(marker)
        }
    }
    
    @objc private func actionCurrentLocation() {
        
        LocationManager.shared.getCurrentLocation(isLiveLocation: false) { location in
            if let location = location{
                self.zoomToLocation(location)
            }
        }
    }
    
    
    private func zoomToLocation(_ location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 10
        )
        mapView.animate(to: camera)
    }
    
}


// MARK: - Map Delegate
extension GoogleMapsViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let index = locations.firstIndex(where: { $0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude }) {
            print("==> location: \(locations[index])")
        }
        
        
        let location = CLLocation(latitude: marker.position.latitude,
                                  longitude: marker.position.longitude)
        zoomToLocation(location)
        
        
        // Highlight selected marker
        for m in markers {
            if let iconView = m.iconView as? UIImageView {
                iconView.layer.borderColor = UIColor.white.cgColor
            }
        }
        
        if let selectedImage = marker.iconView as? UIImageView {
            selectedImage.layer.borderColor = UIColor.systemBlue.cgColor
        }
        
        return false
    }
}

