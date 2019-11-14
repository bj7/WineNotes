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
    
    @IBOutlet weak var yearPicker: UIPickerView!
    
    @IBOutlet weak var wineTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        let year = calendar.component(.year, from: date);
        for i in 500...year {
            years.append(i)
        }
        wineTextField.delegate = self;
        priceTextField.delegate = self;
        yearPicker.dataSource = self;
        yearPicker.delegate = self;

        yearPicker.selectRow(years.count - 3, inComponent: 0, animated: true);
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true);
        wineTextField.resignFirstResponder();
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //For numers
        if textField == priceTextField {
            let allowedCharacters = CharacterSet(charactersIn:"0123456789")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
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
