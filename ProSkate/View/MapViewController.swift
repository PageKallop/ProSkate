//
//  MapViewController.swift
//  ProSkate
//
//  Created by Page Kallop on 3/21/21.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController, SearchViewControllerDelegate, FloatingPanelControllerDelegate {

    let mapView = MKMapView()
    
    let searchVC = SearchViewController()
    
    let panel = FloatingPanelController()
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        searchVC.delegate = self
       
        //sets the floating panel as searchViewController
        panel.delegate = self
        panel.surfaceView.appearance.cornerRadius = 20
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
        panel.move(to: .half, animated: false)
        
    
        //creates back navbarbutton
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.left.2.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(dismissSelf))

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mapView.frame = view.bounds
    }

    //dissmisses VC
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    
    //sets a pin to selected location
    func searchViewController(_ vc: SearchViewController, didSelectLocationWith coordinates: CLLocationCoordinate2D?) {
        
        panel.move(to: .tip, animated: true)
       
        guard let coordinates = coordinates else {
            return
        }
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        mapView.addAnnotation(pin)
        
        mapView.setRegion(MKCoordinateRegion(center: coordinates,
                                             span: MKCoordinateSpan(latitudeDelta: 0.8,
                                                                    longitudeDelta: 0.8)),
                                                                    animated: true)
    }
    
    
    //MARK: - Floating panel layout
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return FloatingPanelStocksLayout()
    }
   
    class FloatingPanelStocksLayout: FloatingPanelLayout {
        let position: FloatingPanelPosition = .bottom
        let initialState: FloatingPanelState = .tip

        var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
            return [
                .full: FloatingPanelLayoutAnchor(absoluteInset: 56.0, edge: .top, referenceGuide: .safeArea),
                .half: FloatingPanelLayoutAnchor(absoluteInset: 450.0, edge: .bottom, referenceGuide: .safeArea),
                .tip: FloatingPanelLayoutAnchor(absoluteInset: 65.0, edge: .bottom, referenceGuide: .safeArea),
            ]
        }

        func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
            return 0.0
        }
    }

    
}
