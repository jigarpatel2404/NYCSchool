//
//  LoadingOverlay.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//


import UIKit
import NVActivityIndicatorView

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator =  NVActivityIndicatorView(frame: CGRect(x: 25, y: 5, width: 50, height: 50), type: .ballClipRotateMultiple, color: .white, padding: NVActivityIndicatorView.DEFAULT_PADDING)
    
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView!) {
        // DispatchQueue.main.async {
        //Main overlay view cover all screen
        if self.overlayView != nil {
            self.overlayView.removeFromSuperview()
        }
        self.overlayView = UIView(frame: UIScreen.main.bounds)
        
        let progressView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        progressView.center = self.overlayView.center
        progressView.backgroundColor = UIColor(hex:"76CAA2")
        progressView.layer.cornerRadius = 8.0
        progressView.alpha = 0.80
        self.activityIndicator =  NVActivityIndicatorView(frame: CGRect(x: 25, y: 8, width: 50, height: 50), type: .ballClipRotateMultiple, color: .white, padding: NVActivityIndicatorView.DEFAULT_PADDING)
        progressView.addSubview(self.activityIndicator)
        let heading = UILabel(frame: CGRect(x: 5, y: 70, width: 90, height: 20))
        heading.text = "Loading"
        heading.font = UIFont(name: "Poppins-Regular", size: 16)
        heading.textColor = UIColor.white
        heading.textAlignment = .center
        progressView.addSubview(heading)
        
        self.overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        
        
        self.overlayView.addSubview(progressView)
        self.activityIndicator.startAnimating()
        view.addSubview(self.overlayView)
        //  }
    }
    
    public func hideOverlayView() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.overlayView.removeFromSuperview()
        }
        
    }

}
