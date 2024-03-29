//
//  ViewController.swift
//  WeatherApp
//
//  Created by Imangazy Magzhan on 24/11/18.
//  Copyright © 2018 Imangazy Magzhan. All rights reserved.


import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var pressureLabel: UILabel!
  @IBOutlet weak var humidityLabel: UILabel!
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var appearentTemperatureLabel: UILabel!
  @IBOutlet weak var refreshButton: UIButton!
  @IBOutlet weak var activiryIndicator: UIActivityIndicatorView!
  
  let locationManager = CLLocationManager()
  
  @IBAction func refreshButtonTapped(_ sender: UIButton) {
    toggleActivityIndicator(on: true)
    fetchCurrentWeatherData()
  }
  
  func toggleActivityIndicator(on: Bool) {
    refreshButton.isHidden = on
    if on {
      activiryIndicator.startAnimating()
    } else {
      activiryIndicator.stopAnimating()
    }
  }
  
  lazy var weatherManager = APIWeatherManager(apiKey: "2a6d8e376a69c1ae07d4a52dd0c2dfdc")
  let coordinates = Coordinates(latitude: 55.755786, longitude: 37.617633)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    
    fetchCurrentWeatherData()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let userLocation = locations.last! as CLLocation
    
    print("my locayion latitude: \(userLocation.coordinate.latitude), longitude: \(userLocation.coordinate.longitude)")
  }
  
  func fetchCurrentWeatherData(){
    weatherManager.fetchCurrentWeatherWith(coordinates: coordinates) { (result) in
      self.toggleActivityIndicator(on: false)
      
      switch result {
      case .Success(let currentWeather):
        self.updateUIWith(currentWeather: currentWeather)
      case .Failure(let error as NSError):
        
        let alertController = UIAlertController(title: "Unable to get data ", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
      default: break
      }
    }
  }
  
  func updateUIWith(currentWeather: CurrentWeather) {
    
    self.imageView.image = currentWeather.icon
    self.pressureLabel.text = currentWeather.pressureString
    self.temperatureLabel.text = currentWeather.temperatureString
    self.appearentTemperatureLabel.text = currentWeather.appearentTemperatureString
    self.humidityLabel.text = currentWeather.humidityString
  }
}












