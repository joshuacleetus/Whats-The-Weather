//
//  ViewController.swift
//  Whats The Weather
//
//  Created by Joshua on 9/22/15.
//  Copyright © 2015 joshuacleetus. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBAction func whatsTheWeather(sender: AnyObject) {
        
        cityTextField.resignFirstResponder()
        
        var wasSuccessful = false
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-") + "/forecasts/latest")
        
        if let url = attemptedUrl {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                if let urlContent = data {
                    
                    let webContent = NSString (data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent?.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray!.count > 1 {
                        
                        let weatherArray = websiteArray![1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            
                            wasSuccessful = true
                            
                            let weatherSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                self.resultLabel.text = weatherSummary
                                
                            })
                            
                        }
                        
                    }
                    
                }
                
                if wasSuccessful == false {
                    
                    self.resultLabel.text = "Couldn't find the weather for that city - please try again"
                    
                }
                
            }
            
            task.resume()
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.resultLabel.text = "Couldn't find the weather for that city - please try again"
                
            })
            
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cityTextField.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        cityTextField.resignFirstResponder()
        
        return true
        
    }


}

