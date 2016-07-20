//
//  LocationEntryViewController.swift
//  ISSTracker
//
//  Created by David Zheng on 7/20/16.
//  Copyright © 2016 David Zheng. All rights reserved.
//

import Foundation
import UIKit

class LocationEntryViewController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stringLocationTextField: UITextField!
    
    @IBOutlet weak var latTextField: UITextField!
    @IBOutlet weak var longTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }
    
    override func viewDidLoad() {
        stringLocationTextField?.delegate = self
        latTextField?.delegate = self
        longTextField?.delegate = self
        
        saveButton.enabled = false
    }
    
    @IBAction func lookupPressed(sender: AnyObject) {
        if let locationString = stringLocationTextField.text {
            LocationRetriever.sharedInstance.getCoordinatesFromAddressString(locationString, completion: { (loc) in
                if loc == nil {
                    print("invalid")
                } else {
                    self.latTextField.text = "\(loc!.lat)"
                    self.longTextField.text = "\(loc!.long)"
                }
            })
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.clearError()
        if textField == stringLocationTextField {
            if let locationString = stringLocationTextField.text {
                if !locationString.isEmpty {
                    self.activityIndicator.startAnimating()
                    self.errorLabel.hidden = true
                    LocationRetriever.sharedInstance.getCoordinatesFromAddressString(locationString, completion: { (loc) in
                        if loc == nil {
                            self.latTextField.text = ""
                            self.longTextField.text = ""
                            self.showErrorWithText("Could Not Find Location")
                            self.errorLabel.hidden = false
                        } else {
                            self.latTextField.text = "\(loc!.lat)"
                            self.longTextField.text = "\(loc!.long)"
                        }
                        self.activityIndicator.stopAnimating()
                        self.updateSaveButtonState()
                    })

                }
            }
        } else {
            updateSaveButtonState()
        }
    }
    
    func updateSaveButtonState() {
        saveButton.enabled = isShowingValidLocation()
    }
    
    func isShowingValidLocation() -> Bool {
        let latText = self.latTextField.text ?? ""
        let longText = self.longTextField.text ?? ""
        if (!latText.isEmpty && !longText.isEmpty) {
            guard let lat = Double(latText) else {
                return false
            }
            guard let long = Double(longText) else {
                return false
            }
            if abs(lat) < 90 && abs(long) < 180 {
                return true
            } else {
                showErrorWithText("Invalid Coordinates")
            }
            return abs(lat) < 90 && abs(long) < 180
            //do stuff
        } else {
            //do stuff
            return false;
        }
    }
    
    func showErrorWithText(message: String) {
        self.errorLabel.text = message
        self.errorLabel.hidden = false
    }
    
    func clearError() {
        self.errorLabel.text = ""
        self.errorLabel.hidden = true
    }
    
}