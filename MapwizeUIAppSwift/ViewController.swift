import UIKit
import MapwizeUI

class ViewController: UIViewController {
    var mapwizeView: MWZMapViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let opts = MWZUIOptions()
        //opts.centerOnPlaceId = "5d08d8a4efe1d20012809ee5";
        let settings = MWZMapwizeViewUISettings()
        mapwizeView = MWZMapViewController(frame: self.view.frame, mapwizeOptions: opts, uiSettings: settings)
        mapwizeView.translatesAutoresizingMaskIntoConstraints = false
        //mapwizeView = MWZMapwizeViewController.init(frame: self.view.frame, mapwizeOptions: opts, uiSettings: settings)
        mapwizeView?.delegate = self
        self.view.addSubview(mapwizeView!)
        
        NSLayoutConstraint.init(item: mapwizeView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
    }
}

extension ViewController: MWZMapViewControllerDelegate {
    
    func mapwizeViewDidLoad(_ mapwizeView: MWZMapViewController!) {
        
    }
    
    func mapwizeViewDidTap(onFollowWithoutLocation mapwizeView: MWZMapViewController!) {
        print("onFollowWithoutLocation")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the follow user mode button but no location has been found",
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeViewDidTap(onMenu mapwizeView: MWZMapViewController!) {
        /*print("onMenu")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the menu",
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)*/
        
        mapwizeView.mapView.mapwizeApi.getPlace(identifier: "5d08d8a4efe1d20012809ee5", success: { (p1) in
            mapwizeView.mapView.mapwizeApi.getPlace(identifier: "569f8d7cb4d7200b003c32a1", success: { (p2) in
                DispatchQueue.main.async {
                    self.mapwizeView.setDirection(MWZDirection(), from: p1, to: p2, isAccessible: true)
                }
            }) { (e2) in
                print(e2)
            }
        }) { (e1) in
            print(e1)
        }
        
    }
    
    func mapwizeView(_ mapwizeView: MWZMapViewController!, didTapOnPlaceInformationButton place: MWZPlace!) {
        print("didTapOnPlaceInformationButton")
        let message = "Click on the place information button \(place.translations[0].title)"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZMapViewController!, didTapOnPlacelistInformationButton placeList: MWZPlacelist!) {
        print("didTapOnPlaceListInformationButton")
        let message = "Click on the placelist information button \(placeList.translations[0].title)"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZMapViewController!, shouldShowInformationButtonFor mapwizeObject: MWZObject!) -> Bool {
        if (mapwizeObject is MWZPlace) {
            return true
        }
        return false
    }
    
    func mapwizeView(_ mapwizeView: MWZMapViewController!, shouldShowFloorControllerFor floors: [MWZFloor]!) -> Bool {
        if (floors.count > 1) {
            return true
        }
        return false
    }
    
}
