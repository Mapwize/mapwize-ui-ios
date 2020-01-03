import UIKit
import MapwizeUI

class ViewController: UIViewController {
    var mapwizeView: MWZUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let opts = MWZUIOptions()
        opts.mainColor = .green
        let settings = MWZUISettings()
        mapwizeView = MWZUIView(frame: self.view.frame, mapwizeOptions: opts, uiSettings: settings)
        mapwizeView.translatesAutoresizingMaskIntoConstraints = false
        mapwizeView?.delegate = self
        self.view.addSubview(mapwizeView!)
        
        NSLayoutConstraint.init(item: mapwizeView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint.init(item: mapwizeView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0).isActive = true
    }
}

extension ViewController: MWZUIViewDelegate {
    
    func mapwizeViewDidLoad(_ mapwizeView: MWZUIView!) {
        
    }
    
    func mapwizeViewDidTap(onFollowWithoutLocation mapwizeView: MWZUIView!) {
        print("onFollowWithoutLocation")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the follow user mode button but no location has been found",
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeViewDidTap(onMenu mapwizeView: MWZUIView!) {
        print("onMenu")
        let alert = UIAlertController.init(title: "User action",
                                           message: "Click on the menu",
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZUIView!, didTapOnPlaceInformationButton place: MWZPlace!) {
        print("didTapOnPlaceInformationButton")
        let message = "Click on the place information button \(place.translations[0].title)"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZUIView!, didTapOnPlacelistInformationButton placeList: MWZPlacelist!) {
        print("didTapOnPlaceListInformationButton")
        let message = "Click on the placelist information button \(placeList.translations[0].title)"
        let alert = UIAlertController.init(title: "User action",
                                           message: message,
                                           preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapwizeView(_ mapwizeView: MWZUIView!, shouldShowInformationButtonFor mapwizeObject: MWZObject!) -> Bool {
        if (mapwizeObject is MWZPlace) {
            return true
        }
        return false
    }
    
    func mapwizeView(_ mapwizeView: MWZUIView!, shouldShowFloorControllerFor floors: [MWZFloor]!) -> Bool {
        if (floors.count > 1) {
            return true
        }
        return false
    }
    
}
