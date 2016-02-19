//
//  ViewController.swift
//  Lazy Friday
//
//  Created by bakerydev004 on 19/2/16.
//  Copyright © 2016 Laura Sirvent Collado. All rights reserved.
//

import UIKit
import STLocationRequest
import ElasticTransition

class ViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var takeMeButton: UIButton!
    
    var transition = ElasticTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        takeMeButton.layer.borderWidth = 1.0
        takeMeButton.layer.borderColor = UIColor .blueColor().CGColor
        takeMeButton.layer.cornerRadius = 4.0
        takeMeButton.setBackgroundImage(getImageWithColor(UIColor.blueColor(), size: takeMeButton.bounds.size), forState: UIControlState.Highlighted)
        
        transition.sticky = true
        transition.showShadow = true
        transition.panThreshold = 0.3
        transition.transformType = .TranslateMid
        
        navigationController?.delegate = transition
        
        let today = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        
        dayLabel.text = NSString(format:"And it is %@", formatter.stringFromDate(today).capitalizedString) as String
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    private func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    @IBAction func takeMeButtonTap(sender: UIButton) {
        
        
    }

}

