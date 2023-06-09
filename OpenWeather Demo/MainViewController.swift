//
//  ViewController.swift
//  OpenWeather Demo
//
//  Created by Tadreik Campbell on 6/1/23.
//

import UIKit
import SwiftUI
import CoreLocation

class MainViewController: UIViewController {
    
    var searchResultsViewModel = SearchResultsViewModel<OpenWeatherLocationFetcher, OpenWeatherFetcher>()
    
    lazy var searchBar: UISearchBar = {
        let v = UISearchBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()
    
    lazy var searchResultsContainer: UIHostingController<SearchResultsView> = {
        let searchResultsView = SearchResultsView(viewModel: searchResultsViewModel)
        let searchResultsContainer = UIHostingController(rootView: searchResultsView)
        searchResultsContainer.view.translatesAutoresizingMaskIntoConstraints = false
        return searchResultsContainer
    }()
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        setUIForSizeClass()
        getLocationPermission()
    }
    
    // iphones and small devices
    private func setupSmallLayout() {
        view.addSubview(searchBar)
        view.addSubview(searchResultsContainer.view)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            searchResultsContainer.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsContainer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsContainer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // ipad and other large devices
    private func setupLargeLayout() {
        view.addSubview(searchBar)
        view.addSubview(searchResultsContainer.view)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            
            searchResultsContainer.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchResultsContainer.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchResultsContainer.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchResultsContainer.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setUIForSizeClass() {
        if traitCollection.horizontalSizeClass == .regular && traitCollection.verticalSizeClass == .regular {
            setupLargeLayout()
        } else {
            setupSmallLayout()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setUIForSizeClass()
    }

}

// MARK: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, !text.isEmpty {
            searchResultsViewModel.search(text)
        }
    }
}

// MARK: - User Location
extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let loc = (location.coordinate.latitude, location.coordinate.longitude)
        searchResultsViewModel.getWeather(location: loc)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func getLocationPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
}

