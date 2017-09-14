//
//  BottomSheet.swift
//  Novoville
//
//  Created by George Avgoustis on 01/09/2017.
//  Copyright © 2017 George Avgoustis. All rights reserved.
//

import UIKit

protocol BottomSheetViewDelegate {
    func bsModeWillSetTo(mode: BottomSheetMode);
    func bsModeDidSetTo(mode: BottomSheetMode);
}

public enum BottomSheetMode{
    case HIDDEN;
    case FULL;
    case SUMMARY;
    case OTHER;
}

public class BottomSheet : UIView, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    //parameters
    var pullupHeightForModeSUMMARY = CGFloat(80); //make this % of parentview
    var hideAnimationDuration = 0.3;
    var showSummaryAnimationDuration = 0.3;
    var showFullAnimationDuration = 0.3;
    //parameters
    
    @IBAction func dismiss(sender: UIButton){
        self.pullUpViewSetMode_SUMMARY()
    }
    
    var parentController : UIViewController?;
    var delegate : BottomSheetViewDelegate?;
    
    public var animFuncForParent : (() -> Void)?
    
    @IBOutlet weak var dismissButton : UIButton?
    @IBOutlet weak var pullupView : UIView!
    @IBOutlet weak var pullUpViewHeightCSTR: NSLayoutConstraint!
    var pullUpViewBottomCSTR: NSLayoutConstraint?
    
    override open func awakeFromNib() {
        dataTable.bounces = false;
        dataTable.isScrollEnabled = false;
        
        dataTable.estimatedRowHeight = 100;
        dataTable.tableFooterView = UIView();

        //performance issues for those two below
        //ADD SHADOW TO PULLUPVIEW
//        pullupView.layer.shadowColor = UIColor.black.cgColor
//        pullupView.layer.shadowOffset = CGSize(width: 0, height: -1.2)
//        pullupView.layer.shadowOpacity = 0.12;
//        pullupView.layer.shadowRadius = 1.1;
        
        //ADD SHADOW TO IMAGE
//        mainImagePullUp?.layer.shadowColor = UIColor.black.cgColor
//        mainImagePullUp?.layer.shadowOffset = CGSize(width: 0, height: -1.2)
//        mainImagePullUp?.layer.shadowOpacity = 0.12;
//        mainImagePullUp?.layer.shadowRadius = 1.1;

    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
    public static func getBottomSheetComponent() -> BottomSheet{
        return Bundle.init(for: self).loadNibNamed("BottomSheet", owner: self, options: nil)![0] as! BottomSheet
    }
    
    var userSetMaxHeightForPullupView:CGFloat = 0;
    public func setUp(parentController: UIViewController,_ tableDelegate : UITableViewDelegate? = nil,_ tableDataSource: UITableViewDataSource? = nil , _ maxBottomSheetHeight : CGFloat = 0 ){
    
        self.parentController = parentController;
        self.mainImagePullUp?.image = self.defaultImageForLocation;
        self.delegate = parentController as? BottomSheetViewDelegate; //is there a case where the delegate isnt the same as the parent ctlr?
        
        //view constraints
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: parentController.view.leftAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: parentController.view.rightAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: parentController.view.frame.height).isActive = true
        
        self.pullUpViewBottomCSTR =  parentController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        self.pullUpViewBottomCSTR!.isActive = true;
        
        //put things in their initial position
        self.pullUpViewBottomCSTR!.constant = -pullUpViewHeightCSTR.constant
        self.mainImagePullUpBottomCSTR.constant = -mainImagePullUp!.frame.height;
        self.navigateCarButton?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        
        //view constraints
        
        //pullup view height set
        self.userSetMaxHeightForPullupView = maxBottomSheetHeight;
    
        //Use either the default table fields and cells or use ones specified by the parent controller
        if(tableDelegate != nil){
            self.dataTable.delegate = tableDelegate
        }else{
            dataTable.delegate = self;
        }
        
        if(tableDataSource != nil){
            self.dataTable.dataSource = tableDataSource
        }else{
            dataTable.dataSource = self;
        }
    }
    
    var userData = [String:String]()
    
    public func setData(data: [String:String]){
    
        self.userData = data
        self.displayFields = parseDefaultDataDict(dict: userData)
        self.dataTable.reloadData()
        self.dataTable.layoutIfNeeded()
        
        if(self.userData["photoUrl"] != nil){
            self.getImageForMainImage(imageUrl: self.userData["photoUrl"]!) { (theImage) in
                self.mainImagePullUp?.image = theImage
            }
        }
        
        //if the height is set below 250 by the user ( which i dont think makes much sense TODO re-examine
        //then we just make it so that the maxheight is to whatever it needs to be so that the image + that height fill upp the view
        //otherwise, we set it to maxheight
        if(self.userSetMaxHeightForPullupView < 250){
            //the reason im doing it like this here is because i want the component to be reusable for controllers that arent necessarily
            //navigation controllers
            var heightOfNavBar = self.parentController?.navigationController?.navigationBar.frame.height ?? 0
            let statusBarHeight = UIApplication.shared.statusBarFrame.height
            
            
//            pullUpViewHeightCSTR.constant = self.parentController!.view.frame.height - mainImagePullUpHeightCSTR.constant - statusBarHeight - heightOfNavBar
            
            var k = self.parentController?.navigationController
            if(k == nil){
                pullUpViewHeightCSTR.constant = self.parentController!.view.frame.height - mainImagePullUpHeightCSTR.constant - statusBarHeight
            }else{
                pullUpViewHeightCSTR.constant = self.parentController!.view.frame.height - mainImagePullUpHeightCSTR.constant
            }
            
            
            
        }else{
            pullUpViewHeightCSTR.constant = self.userSetMaxHeightForPullupView;
        }
        
        //WHEN WE SET THE DATA, THE RESULTING TABLE CONTENT MIGHT BE TOO LITTLE
        //AND THIS WILL RESULT IN AN UGLY VIEW WHEN THE BOTOTMSHEET IS PULLED ALL THE WAY UP
        //FOR THAT REASON, IF THE CONTENT ISNT ENOUGH TO FILL 2/3 OF THE PARENT VIEW, WE CONSTRAIN IT TO
        //WHAT IT CAN FILL AND DONT ALLOW FOR IT TO GO HIGHER THAN THAT.
        var tableContentSize = self.dataTable.contentSize.height;
        var twoThirdsOfParentHeight = self.parentController!.view.frame.height*CGFloat(0.60)
        print(tableContentSize)
        print(twoThirdsOfParentHeight)
        if(tableContentSize < twoThirdsOfParentHeight){
            pullUpViewHeightCSTR.constant = tableContentSize;
        }
        
        self.pullUpViewBottomCSTR!.constant = -pullUpViewHeightCSTR.constant
    }
    
    func setImageHidingOverlayColor(color: UIColor){
        obscuringFadeEffectView.backgroundColor = color;
    }
    
    //This is needed for the gesture to be captured while table scrolling
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if(gestureRecognizer.view == pullupView){
            if(getMode() == .SUMMARY){
                return true;
            }else{
                return false;
            }
        }
        
        return true;
    }
    
    ///////////
    //MARK: - DEFAULT TABLE METHODS
    ///////////
    
    @IBOutlet weak var dataTable : UITableView!
    
    var displayFields = [UITableViewCell]()
    func parseDefaultDataDict(dict : [String:String]) -> [UITableViewCell]{
        
        var tempArr = [UITableViewCell]()
        
        var title = dict["title"];
        var desc = dict["description"];
        
        if(title != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("TitleAndDescriptionPOICell", owner: self, options: nil)![0] as! TitleAndDescriptionPOICell
            cell.setData(title: title!, description: desc)
            tempArr.append(cell)
        }
        
        var email = dict["email"]
        if(email != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BottomSheetIconAndTextCell" , owner: self, options: nil)![0] as! BottomSheetIconAndTextCell
            cell.setData(title: email!, type: "email")
            tempArr.append(cell)
        }
        
        var phone = dict["phone"]
        if(phone != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BottomSheetIconAndTextCell" , owner: self, options: nil)![0] as! BottomSheetIconAndTextCell
            cell.setData(title: phone!, type: "phone")
            tempArr.append(cell)
            //this is to be a placeholder
        }
        
        var openHours = dict["openHours"]
        if(openHours != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BottomSheetIconAndTextCell" , owner: self, options: nil)![0] as! BottomSheetIconAndTextCell
            cell.setData(title: openHours!, type: "openHours")
            tempArr.append(cell)
        }
        
        var address = dict["address"]
        if(address != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BottomSheetIconAndTextCell" , owner: self, options: nil)![0] as! BottomSheetIconAndTextCell
            cell.setData(title: address!, type: "address")
            tempArr.append(cell)
        }
        
        var on_duty = dict["on_duty"]
        if(on_duty != nil){
            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BottomSheetIconAndTextCell" , owner: self, options: nil)![0] as! BottomSheetIconAndTextCell
            cell.setData(title: "Open tonight", type: "on_duty")
            tempArr.append(cell)
        }
        
        //        var openDays = dict["openDays"]
        //        if(openDays != nil){
        //            var cell = Bundle.init(for: BottomSheet.self).loadNibNamed("BSDaysOpenCell" , owner: self, options: nil)![0] as! BSDaysOpenCell
        //            cell.setData(daysOpen: openDays!)
        //            tempArr.append(cell)
        //        }
        
        return tempArr;
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayFields.count;
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return displayFields[indexPath.row];
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var theCell = tableView.cellForRow(at: indexPath) as? BottomSheetIconAndTextCell;
        
        if(theCell == nil){
            return;
        }
        
        if(theCell!.type == "email"){
            let emailaddr: String = "mail://" + theCell!.titleLabel!.text!
            UIApplication.shared.openURL(URL(string: emailaddr)!)
        }
        
        if(theCell!.type == "phone"){
            let phoneNumber: String = "tel://" + theCell!.titleLabel!.text!
            UIApplication.shared.openURL(URL(string: phoneNumber)!)
        }
        
        if(theCell!.type == "address"){
            openGoogleMaps()
        }
        
        
    }
    
    ////////////
    //MARK: - PAN GESTURES AND TABLE SCROLL
    ////////////
    
    var dontScrollPullUp = false;
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("table offset: \(dataTable.contentOffset.y)\n")
        
        if(dataTable.contentOffset.y == 0){
            dataTable.isScrollEnabled = false;
            dontScrollPullUp = false;
            print("offset: table scrolled up, table OFF, pullup ON")
        }else{
            print("offset: table scrolled up, table OFF, pullup ON")
            dataTable.isScrollEnabled = true;
            dontScrollPullUp = true;
        }
    }
    
    //TODO: FIGURE OUT THE WHOLE SWIPE THING
    @IBAction func handleSwipeUp(recognizer: UISwipeGestureRecognizer){
        if(recognizer.state == .ended){
            print("swiped up")
//                    self.pullUpViewSetMode_FULL()
        }
        
    }
    
    @IBAction func handleSwipeDown(recognizer: UISwipeGestureRecognizer){
        print("swiped down")
//        self.pullUpViewSetMode_SUMMARY()
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        //if the gesture has ended and we ve panned enough,
        //then slide it all the way up
        if(recognizer.state == .ended){
            
            print("Velocty")
            print(recognizer.velocity(in: self).y)
            
            if(recognizer.velocity(in: self).y > CGFloat(500) ){
                self.pullUpViewSetMode_SUMMARY()
                return;
            }
            
            if(recognizer.velocity(in: self).y < CGFloat(-500) ){
                self.pullUpViewSetMode_FULL()
                return;
            }
            
            if(pullUpProgress() > CGFloat(0.50)){
                self.pullUpViewSetMode_FULL()
            }else{
                self.pullUpViewSetMode_SUMMARY()
            }
            
        }
        
        
        
        parallaxImage()
//        print("Pullup progress: \(pullUpProgress())")
        let translation = recognizer.translation(in: self)
        
        //if its about to below a specific threshold, stop it
        if(pullUpViewBottomCSTR!.constant <=  -pullUpViewHeightCSTR.constant + pullupHeightForModeSUMMARY){
            
            //if you wanted to go further down, wa ikemasen
            if(translation.y > 0){
                pullUpViewBottomCSTR!.constant = -pullUpViewHeightCSTR.constant + pullupHeightForModeSUMMARY
                //                recogniserView.frame.origin.y = self.view.frame.height - pullupHeightForModeSUMMARY
                //                self.view .layoutIfNeeded()
                return;
            }
        }
        
        //if its about to go above its own height, stop it
        if(pullUpViewBottomCSTR!.constant >= CGFloat(0)){
            
            //if you do it fast it might translate a bit further out and overshoot so we need to correct it
            print("table ON")
            dataTable.isScrollEnabled = true;
            
            //if you wanted to go further up, wa ikemasen
            if(translation.y < 0){
                pullUpViewBottomCSTR!.constant = 0;
                return;
            }
        }else{
            print("table OFF")
            dataTable.isScrollEnabled = false;
            dontScrollPullUp = false;
        }
        
        
        if(dontScrollPullUp){
            //since we havent really been scrolling the pullupview, that means that
            //we need to set the recogniser to zero otherwise it would JUMP when the pullup view
            //was enabled again and had to cover a distance of say 50 points
            recognizer.setTranslation(CGPoint.init(x: 0, y: 0), in: self)
            return;
        }
   
        
        //maybe optimise this bit because we re setting it to over 0 and then we re correcting.. we shouldnt prolly
        pullUpViewBottomCSTR!.constant = pullUpViewBottomCSTR!.constant - translation.y
        recognizer.setTranslation(CGPoint.zero, in: self)
    }
    
    @IBAction func handleTapPullUpSheet( recognizer: UITapGestureRecognizer){
        self.pullUpViewSetMode_FULL()
    }
    
    ///////////
    ///////////
    // hiding, showing pullup sheet, tapping it to expand all the way
    
    private var isPullUpViewShowing = true;
    
    
    //shows only on the bottom in summary mode
    public func pullUpViewSetMode_SUMMARY(){
        
        self.returnToNormalSizeNavigateButton()
        self.delegate?.bsModeWillSetTo(mode: .SUMMARY)
        
        UIView.animate(withDuration: self.showSummaryAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.pullUpViewBottomCSTR!.constant = -self.pullUpViewHeightCSTR.constant + self.pullupHeightForModeSUMMARY
            self.mainImagePullUpBottomCSTR.constant = -self.mainImagePullUp!.frame.height
            self.dataTable.isScrollEnabled = false;
            self.superview?.layoutIfNeeded()
        }) { (completed) in
            self.delegate?.bsModeDidSetTo(mode: .SUMMARY)
        }
    }
    
    public func pullUpViewSetMode_HIDDEN(){
        
        shrinkOutNavigateButton()
        self.delegate?.bsModeWillSetTo(mode: .HIDDEN)
        
        UIView.animate(withDuration: self.hideAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            self.pullUpViewBottomCSTR!.constant = -self.pullUpViewHeightCSTR.constant
            self.mainImagePullUpBottomCSTR.constant = -self.mainImagePullUp!.frame.height
            self.animFuncForParent!()
            self.superview?.layoutIfNeeded()
            self.dataTable.isScrollEnabled = false;
            
        }) { (completed) in
            self.delegate?.bsModeDidSetTo(mode: .HIDDEN)
        }
        
    }
    
    public func pullUpViewSetMode_FULL(){
        
        //if someone has half dragged this we dont want tapping on it to show full mode
        //because they may be tapping to select an item
        if(getMode() == .FULL){
            return;
        }
        
        self.delegate?.bsModeWillSetTo(mode: .FULL)
        
        self.dataTable.isScrollEnabled = true;
        
//        self.layoutIfNeeded()
//        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: self.showFullAnimationDuration, delay: 0.0, options: .curveEaseOut, animations: {
            
            self.pullUpViewBottomCSTR!.constant = 0
            self.mainImagePullUpBottomCSTR.constant = 0
            
            self.obscuringFadeEffectView.alpha = 0;
            self.dismissButton?.alpha = 1
            
            self.superview?.layoutIfNeeded()
        }) { (completed) in
            self.delegate?.bsModeDidSetTo(mode: .FULL)
        }
    }
    
    public func getMode() -> BottomSheetMode{
        if(pullUpViewBottomCSTR!.constant == 0){
            return .FULL;
        }
        
        if(pullUpViewBottomCSTR!.constant == -self.pullUpViewHeightCSTR.constant + self.pullupHeightForModeSUMMARY){
            return .SUMMARY;
        }
        
        if(pullUpViewBottomCSTR!.constant == -self.pullUpViewHeightCSTR.constant){
            return .HIDDEN;
        }
        
        return .OTHER;
    }
    
    //////////
    //IMAGE RELATED STUFF
    //////////
    
    @IBOutlet weak var mainImagePullUp: UIImageView?
    @IBOutlet weak var mainImagePullUpHeightCSTR: NSLayoutConstraint!
    @IBOutlet weak var mainImagePullUpBottomCSTR: NSLayoutConstraint!
    @IBOutlet weak var obscuringFadeEffectView : UIView!
    var defaultImageForLocation = UIImage(named: "defaultImage.jpeg", in: Bundle.init(identifier: "com.malforked.BottomSheet"), compatibleWith: nil)

    func pullUpProgress() -> CGFloat{
        
        var currentYPos = pullUpViewBottomCSTR!.constant +  pullUpViewHeightCSTR.constant - pullupHeightForModeSUMMARY
        var totalArea = (pullUpViewHeightCSTR.constant - pullupHeightForModeSUMMARY)
        
        return currentYPos/totalArea;
    }
    
    private func parallaxImage(){
        
        mainImagePullUpBottomCSTR.constant = mainImagePullUp!.frame.height*pullUpProgress() - mainImagePullUp!.frame.height;
        
        var calculatedAlpha = (1 - pullUpProgress()) + 0.10
        obscuringFadeEffectView.alpha = calculatedAlpha;
        dismissButton?.alpha = 1 - calculatedAlpha;
    }
    
    ///////////
    //MARK: - OTHER
    //////////
    @IBOutlet weak var navigateCarButton : UIButton?
    
    @IBAction func navigateCarButtonPressed(sender: UIButton){
        openGoogleMaps()
    }
    
    func openGoogleMaps(){
        
        var lat = self.userData["latitude"]
        var lon = self.userData["longitude"]
        
        if(lat == nil || lon == nil){
            return;
        }
        
        var stringtouse = "comgooglemaps://?saddr=&daddr=" + lat! + "," + lon! + "&directionsmode=walking"
        //        self.delegate?.navigateButtonPressed()
        //TODO WHY DOES THIS RETURN FALSE!?!?!?
        //            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
        
        UIApplication.shared.openURL(URL(string:stringtouse)!)
        //            } else {
        //                print("Can't use comgooglemaps://");
        //
    }
    
    func shrinkOutNavigateButton(){
        
        UIView.animate(withDuration: hideAnimationDuration, animations: {
            self.navigateCarButton?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
        }) { (finished) in
            
        }
    }
    
    func returnToNormalSizeNavigateButton(){
        
        UIView.animate(withDuration: showSummaryAnimationDuration, delay: showSummaryAnimationDuration, options: .curveEaseInOut, animations: {
            self.navigateCarButton?.transform = CGAffineTransform.identity
        }) { (done) in
            
        }
    }
    
    private func getImageForMainImage(imageUrl: String, completion: @escaping (UIImage) -> Void){
        
        var retrievedImage : UIImage?
        
        if(imageUrl != ""){
            
            let priority = DispatchQueue.GlobalQueuePriority.default
            DispatchQueue.global(priority: priority).async {
                // do some task
                let url = URL(string:imageUrl)
                if(url != nil){
                    let data = try? Data(contentsOf: url!)
                    
                    if data != nil {
                        retrievedImage = UIImage(data:data!)
                        
                        DispatchQueue.main.async {
                            // update some UI
                            completion(retrievedImage!)
                        }
                        
                    }else{
                        completion(self.defaultImageForLocation!)
                        //                        self.photo = UIImage(named:"novovilleLogo")
                    }
                    
                }else{
                    completion(self.defaultImageForLocation!)
//                    log.error("why this happen !@#%%^^^")
                }
            }
        }else{
            completion(self.defaultImageForLocation!)
            //            self.photo = UIImage(named:"novovilleLogo")
            //            DispatchQueue.main.async {
            //                // update some UI
            //                toTrapezi.reloadData()
            //            }
        }
        
    }
    
}

//////
//The difference between animating constraints and updating them by hand is a thing thats troubled me in this library.
//You can "hook" in into the animation using
//https://stackoverflow.com/questions/22582192/ios-observing-change-in-frame-of-a-uiview-during-animation
//TOSTUDY later

