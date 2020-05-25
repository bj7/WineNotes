//
//  CenterViewController.swift
//  WineNotes
//
//  Created by Joshua Bernitt on 4/25/19.
//  Copyright © 2019 Joshua Bernitt. All rights reserved.
//

import UIKit;

class NoteEntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    var years:[Int] = [];
    var overallRatings:[Int] = [];
    let date = Date();
    let calendar = Calendar.current;
    var activeTextField: UITextField!;
    var activeTextView: UITextView!;
    
    // called by on tap event
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
//        self.activeTextField.endEditing(true);
        self.activeTextField = nil;
        self.activeTextView = nil;
    }
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var wineTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var overallRatingPicker: UIPickerView!
    override func viewDidLoad() {
        let year = calendar.component(.year, from: date);
        for i in 500...year {
            years.append(i)
        }
        for i in 50...100 {
            overallRatings.append(i);
        }
        wineTextField.delegate = self;
        priceTextField.delegate = self;
        self.priceTextField.keyboardType = UIKeyboardType.decimalPad;
        yearPicker.dataSource = self;
        yearPicker.delegate = self;
        yearPicker.selectRow(years.count - 3, inComponent: 0, animated: true);
        regionTextField.delegate = self;
        countryTextField.delegate = self;
        notesTextView.delegate = self
        
        overallRatingPicker.delegate = self;
        overallRatingPicker.dataSource = self;
        
        // observers to handle when the keyboard comes into and
        // out of focus
        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillShow(_:)),
          name: UIResponder.keyboardWillShowNotification,
          object: nil)

        NotificationCenter.default.addObserver(
          self,
          selector: #selector(keyboardWillHide(_:)),
          name: UIResponder.keyboardWillHideNotification,
          object: nil)
    }
    
    /**
     Text Field Handling
     */
    // enables keyboard hiding upon return button click
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        self.activeTextField.resignFirstResponder();
        return true;
    }
    
    // basic validation
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == priceTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789.")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    // Assign the newly active text field to activeTextField variable
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    /*
     Why the heck is textFieldDidBeginEditing called prior to keyboard notification
     but textViewDidBeginEditing isn't?? Now I gotta use shouldBeginEditing so I can
     set the active text input so it isn't nil when determing the offset of
     the keyboard
     */
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self.activeTextView = textView
        return true
    }
    
    // adjust keyboard inset height and correct for overlapping input elements
    func adjustInsetForKeyboard(_ show: Bool, notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else {
            return;
        }
        
        var viewRect = view.frame
        let textField = self.activeTextView === nil ? self.activeTextField : self.activeTextView
        // shrink view field by keyboard height since that will be the total space
        // allowed while keyboard is active
        viewRect.size.height -= keyboardFrame.cgRectValue.height
        // get bottom y-coordinate of textfield
        let bottomOfTextField = textField!.frame.origin.y + textField!.frame.size.height
        
        /*
         If keyboard covers bottom of text field, scroll amount of overlap
         */
        if show && (viewRect.height < (bottomOfTextField)) {
            let scrollPoint = CGPoint(x: 0, y: bottomOfTextField - keyboardFrame.cgRectValue.height)
            scrollView.setContentOffset(scrollPoint, animated: true)
        } else { // reset contentInset
            scrollView.contentInset = UIEdgeInsets.zero
            scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        self.adjustInsetForKeyboard(true, notification: notification);
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.adjustInsetForKeyboard(false, notification: notification);
    }
    
    
    /**
     Picker handling
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return years.count;
        } else {
            return overallRatings.count;
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return String(years[row]);
        } else {
            return String(overallRatings[row]);
        }
    }
}
