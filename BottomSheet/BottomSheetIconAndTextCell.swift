//
//  File.swift
//  Novoville
//
//  Created by George Avgoustis on 04/09/2017.
//  Copyright © 2017 George Avgoustis. All rights reserved.
//

import UIKit

class BottomSheetIconAndTextCell : UITableViewCell{
    
    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var iconImgView : UIImageView?
    var type = "none"; //enum this
    
    func setData(title: String, type : String){
        titleLabel?.text = title;
        self.type = type;
        
        switch (type){
            case "email":
                iconImgView?.image = UIImage(named: "mailOutline")
            case "phone":
                iconImgView?.image = UIImage(named: "phoneIcon")
            case "openHours":
                iconImgView?.image = UIImage(named: "accessTime")
            case "address":
                iconImgView?.image = UIImage(named: "locationPinBottomSheet")
            case "onduty":
                iconImgView?.image = UIImage(named: "onduty")
            default:
                iconImgView?.image = UIImage(named: "mailOutline")
        }
    }
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
    
}
