//
//  ViewController.swift
//  BottomSheetApp
//
//  Created by George Avgoustis on 12/09/2017.
//  Copyright © 2017 Malforked. All rights reserved.
//

import UIKit
import BottomSheet


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var bottomSheet: BottomSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var customData = [String:String]()
        customData["email"] = "testemail@a.com"
        customData["address"] = "Wherever lane"
        customData["openHours"] = "12:34 - 15:22"
        customData["title"] = "Getwell Pharmacy"
        customData["description"] = "All of our products guarantee ultimate satisfaction and wellness improving your daily health by a factor of 10000% and thats an actual number derived from research we didnt come up with it we promise.";
        customData["phone"] = "+4412345223"
        
        //////////////
        //SETTING UP THE BOTTOM SHEET
        //////////////
        BottomSheet.getBottomSheetComponent();
        
        //METHOD A) Using Custom Data
        bottomSheet!.setUp(parentController: self)
        bottomSheet!.setData(data: customData)
        
        //METHOD B) For extra customization. Using your own table and cells
//        bottomSheet!.setUp(parentController: self, tableDelegate: self, tableDataSource: self, maxBottomSheetHeight: 0)
        
        //Show bottom sheet in summary mode.
        bottomSheet!.pullUpViewSetMode_SUMMARY()
        
        
        //////////
        //ADDING CALLBACKS
        ////////
        
        bottomSheet!.animFuncForParent = self.doSomething
        
    }
    
    //IF you re using METHOD B) then you NEED to implement scrollViewDidScroll and add scrollViewDidScroll
    //on it as the BottomSheet component needs this. If anyone has a better idea on how to structure this im all ears, drop me a line.
    //Generally multiple delegates are not considered a good idea : https://stackoverflow.com/questions/12774808/multiple-delegates-in-ios
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomSheet!.scrollViewDidScroll(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.textLabel?.text = "Custom cell"
        return cell;
    }
    
    
    ////
    //OTHER
    ///
    
    func doSomething(){
        print("za")
    }

}

