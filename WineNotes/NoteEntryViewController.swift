//
//  CenterViewController.swift
//  WineNotes
//
//  Created by Joshua Bernitt on 4/25/19.
//  Copyright © 2019 Joshua Bernitt. All rights reserved.
//

import UIKit;

class NoteEntryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    var years:[Int] = [];
    let date = Date();
    let calendar = Calendar.current;
    var activeTextField: UITextField!;
    
    // called by on tap event
    @IBAction func hideKeyboard(_ sender: AnyObject) {
        self.activeTextField.endEditing(true);
        self.activeTextField = nil;
    }
    @IBOutlet weak var yearPicker: UIPickerView!
    @IBOutlet weak var wineTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var varietyTextField: UITextField!
    @IBOutlet weak var recommendedTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        let year = calendar.component(.year, from: date);
        for i in 500...year {
            years.append(i)
        }
        
        wineTextField.delegate = self;
        priceTextField.delegate = self;
        self.priceTextField.keyboardType = UIKeyboardType.decimalPad;
        yearPicker.dataSource = self;
        yearPicker.delegate = self;
        yearPicker.selectRow(years.count - 3, inComponent: 0, animated: true);
        regionTextField.delegate = self;
        varietyTextField.delegate = self;
        recommendedTextField.delegate = self;
        
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
    
    // adjust keyboard inest height and correct for overlapping input elements
    func adjustInsetForKeyboard(_ show: Bool, notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else {
            return;
        }
        
        let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1);
        scrollView.contentInset.bottom += adjustmentHeight;
        scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight;
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
        return years.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(years[row]);
    }
}
