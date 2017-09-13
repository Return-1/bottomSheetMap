//
//  File.swift
//  Novoville
//
//  Created by George Avgoustis on 04/09/2017.
//  Copyright © 2017 George Avgoustis. All rights reserved.
//

import UIKit

class TitleAndDescriptionPOICell : UITableViewCell{

    @IBOutlet weak var titleLabel : UILabel?
    @IBOutlet weak var descriptionLabel : UILabel?
    
    override func awakeFromNib() {
        selectionStyle = .none;
    }
    
    func setData(title: String, description : String?){
        titleLabel?.text = title
        descriptionLabel?.text = description
    }
    
}
