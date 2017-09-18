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
                iconImgView?.image = UIImage(named: "mailOutline", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
            case "phone":
                iconImgView?.image = UIImage(named: "phoneIcon", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
            case "openHours":
                iconImgView?.image = UIImage(named: "accessTime", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
            case "address":
                iconImgView?.image = UIImage(named: "locationPinBottomSheet", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
            case "on_duty":
                iconImgView?.image = UIImage(named: "onduty", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
            default:
                iconImgView?.image = UIImage(named: "mailOutline", in: Bundle.init(identifier: "com.malforked.BottomSheetMap"), compatibleWith: nil)
        }
    }
    
    override func awakeFromNib() {
        selectionStyle = .none
    }
}
