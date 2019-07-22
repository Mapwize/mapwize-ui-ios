import UIKit
import MapwizeUI

class ViewController: UIViewController {
    
    var mapwizeView: MWZMapwizeView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let opts = MWZUIOptions()
        //opts.centerOnPlaceId = "5bc49413bf0ed600114db212"
        opts.centerOnVenueId = "56b20714c3fa800b00d8f0b5"
        //opts.centerOnLocation = MWZLatLngFloor(latitude: 50.6331, longitude: 3.0198, floor: 0)
        
        let settings = MWZMapwizeViewUISettings()
        settings.followUserButtonIsHidden = false
        settings.menuButtonIsHidden = false
        settings.mainColor = .orange
        
        mapwizeView = MWZMapwizeView.init(frame: self.view.frame, mapwizeOptions: opts, uiSettings: settings)
        mapwizeView?.delegate = self
        self.view.addSubview(mapwizeView!)
    }
}

extension ViewController: MWZMapwizeViewDelegate {
    
    func mapwizeViewDidLoad(_ mapwizeView: MWZMapwizeView!) {
        
    }
    
    func mapwizeViewDidTap(onFollowWithoutLocation mapwizeView: MWZMapwizeView!) {
        print("onFollowWithoutLocation")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the follow user mode button but no location has been found",
                                           preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeViewDidTap(onMenu mapwizeView: MWZMapwizeView!) {
        print("onMenu")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the menu",
                                           preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZMapwizeView!, didTapOnPlaceInformationButton place: MWZPlace!) {
        print("didTapOnPlaceInformationButton")
        let message = "Click on the place information button \(place.translations[0].title ?? "")"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZMapwizeView!, didTapOnPlaceListInformationButton placeList: MWZPlaceList!) {
        print("didTapOnPlaceListInformationButton")
        let message = "Click on the placelist information button \(placeList.translations[0].title ?? "")"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .actionSheet)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZMapwizeView!, shouldShowInformationButtonFor mapwizeObject: MWZObject!) -> Bool {
        if (mapwizeObject is MWZPlace) {
            return true
        }
        return false
    }
    
    func mapwizeView(_ mapwizeView: MWZMapwizeView!, shouldShowFloorControllerFor floors: [NSNumber]!) -> Bool {
        if (floors.count > 1) {
            return true
        }
        return false
    }
    
}
