//
//  BSDaysOpenCell.swift
//  Novoville
//
//  Created by George Avgoustis on 11/09/2017.
//  Copyright © 2017 George Avgoustis. All rights reserved.
//

import UIKit
//import BadgeSwift

class BSDaysOpenCell : UITableViewCell {
    
    @IBOutlet weak var stackView : UIStackView!
    
    @IBInspectable var dayActiveColor: UIColor? {
        didSet {
            dayActiveBackgroundColor = dayActiveColor
        }
    }
    
    var dayActiveBackgroundColor: UIColor? = UIColor.init(red: 48/255, green: 122/255, blue: 255/255, alpha: 1);
    
    override func awakeFromNib() {
        
    }
    
    func setData(daysOpen: String){
//        
        var boolArr = [Bool]();
        
        for character in daysOpen.characters{
            var ch = String(character)
            if( ch == "1"){
                boolArr.append(true)
            }else{
                boolArr.append(false)
            }
        }
        
        for i in 0..<stackView.arrangedSubviews.count{
            var a = (stackView.arrangedSubviews[i] as! UILabel)
            
            //make uilabel round
            //this makes them diamond shaped, some constraint issue, investigate
            a.layer.cornerRadius = a.frame.width / 2;
            a.layer.masksToBounds = true
            
            if(boolArr[i]){
                a.backgroundColor = dayActiveBackgroundColor
                a.textColor = UIColor.white
                
            }else{
                a.backgroundColor = UIColor.white
                a.textColor = UIColor.black;
            }
            
            
            
        }
        
    }
    
}
