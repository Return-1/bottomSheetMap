# bottomSheetMap
Emulating the bottom sheet component found in google maps

There are two ways to use the BottomSheet component.

## Load the component

BottomSheet.getBottomSheetComponent();

## Method A)

Using the default display views. Provide a dictionary with fields as described below and let BottomSheet take care of the rest.

```
        var customData = [String:String]()
        customData["email"] = "testemail@a.com"
        customData["address"] = "Wherever lane"
        customData["openHours"] = "12:34 - 15:22"
        customData["title"] = "Getwell Pharmacy"
        customData["description"] = "The description. All of our products guarantee ultimate satisfaction and wellness improving your daily health by a factor of 10000% and thats an actual number derived from research we didnt come up with it we promise.";
        customData["phone"] = "+4412345223"

        bottomSheet!.setUp(parentController: self)
        bottomSheet!.setData(data: customData)
```
 
 ## Method B)

You can provide your own table methods if you would rather use your own custom cells.

```
    bottomSheet!.setUp(parentController: self, tableDelegate: self, tableDataSource: self, maxBottomSheetHeight: 0)
```

If you re using method B) then you NEED to implement scrollViewDidScroll and add scrollViewDidScroll on it as the BottomSheet component needs this.

```
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomSheet!.scrollViewDidScroll(scrollView)
    }
```

Note : If anyone has a better idea on how to structure this im all ears, drop me a line. Generally multiple delegates are not considered a good idea : https://stackoverflow.com/questions/12774808/multiple-delegates-in-ios

##Finishing up

Display your bottomSheet by calling
```
bottomSheet!.pullUpViewSetMode_SUMMARY()
```
