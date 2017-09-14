//
//  ViewController.swift
//  BottomSheetApp
//
//  Created by George Avgoustis on 12/09/2017.
//  Copyright © 2017 Malforked. All rights reserved.
//

import UIKit
import BottomSheet


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, BottomSheetViewDelegate {

    var bottomSheet: BottomSheet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var customData = [String:String]()
        customData["email"] = "testemail@a.com"
        customData["address"] = "Wherever lane"
        customData["openHours"] = "12:34 - 15:22"
        customData["title"] = "Getwell Pharmacy"
        customData["phone"] = "+4412345223"
        customData["description"] = "All of our products guarantee ultimate satisfaction and wellness improving your daily health by a factor of 10000% and thats an actual number asd as asd asd as asda das das das dads ena ena ena ena ena ena ena ena ena ena ena dio dio dio dio dio doi dio dio dio dio dio dio dio dio dio dio dio";
        
        //if you want the navigation button to work, also provide longitute and latitude
        customData["longitude"] = "48.8722344"
        customData["latitude"] = "2.7758079"
        customData["on_duty"] = "2.7758079"
        
        //////////////
        //SETTING UP THE BOTTOM SHEET
        //////////////
        var bottomSheet = BottomSheet.getBottomSheetComponent();
        self.view.addSubview(bottomSheet);
        
        //METHOD A) Using Custom Data
        bottomSheet.setUp(parentController: self)
        
        bottomSheet.setData(data: customData)
        
        
        
        
        
        //METHOD B) For extra customization. Using your own table and cells
//        bottomSheet!.setUp(parentController: self, tableDelegate: self, tableDataSource: self, maxBottomSheetHeight: 0)
        
        //Show bottom sheet in summary mode.
        delay(1){
            bottomSheet.pullUpViewSetMode_SUMMARY()
        }
        
        
        //////////
        //ADDING CALLBACKS
        ////////
        
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
   
    
    /////
    //Delegate methods
    ////
    
    func bsModeDidSetTo(mode: BottomSheetMode) {
        print(mode)
    }
    
    func bsModeWillSetTo(mode: BottomSheetMode) {
        print(mode)
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    ////
    //OTHER
    ///

}

