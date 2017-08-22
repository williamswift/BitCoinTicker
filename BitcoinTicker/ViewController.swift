//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
 

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
       
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        getBitcoinPriceData(url: finalURL)
    }
    

    
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getBitcoinPriceData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Sucess! Got Bitcoing pricing Data")
                    let BitcoinJSON : JSON = JSON(response.result.value)
                    
                    self.updateBitcoinPricingData(json: BitcoinJSON)
                    
                } else {
                    print("Error: \(response.result.error)")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    func updateBitcoinPricingData(json : JSON) {
        
        if let pricingResult = json["open"]["day"].double {
        
                bitcoinPriceLabel.text = String(pricingResult)
    }
        else {
            bitcoinPriceLabel.text = "data unavailable"
        }
    




}

}
