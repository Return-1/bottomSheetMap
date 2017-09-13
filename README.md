# bottomSheetMap
Emulating the bottom sheet component found in google maps

There are two ways to use the BottomSheet component.

### Step 1.

Load the component 
```swift
BottomSheet.getBottomSheetComponent();
```
### Step 2 Method A

Using the default display views. Provide a dictionary with fields as described below and let BottomSheet take care of the rest.

```swift
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
 
 ### Step 2 Method B

You can provide your own table methods if you would rather use your own custom cells.

```swift
    bottomSheet!.setUp(parentController: self, tableDelegate: self, tableDataSource: self, maxBottomSheetHeight: 0)
```

If you re using method B) then you NEED to implement scrollViewDidScroll and add scrollViewDidScroll on it as the BottomSheet component needs this.

```swift
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        bottomSheet!.scrollViewDidScroll(scrollView)
    }
```

Note : If anyone has a better idea on how to structure this im all ears, drop me a line. Generally multiple delegates are not considered a good idea : https://stackoverflow.com/questions/12774808/multiple-delegates-in-ios

### Step 2 Method c
Coming soon... Working on a solution that can mix and max methods B and A

### Step 3

You're done! Display your bottomSheet by calling
```swift
bottomSheet!.pullUpViewSetMode_SUMMARY()
```

### Customization

When initializing the BottomSheet you can either sepcify a maxHeight or leave it on automatic.

#### Automatic:
```swift
        bottomSheet!.setUp(parentController: self)
```
#### Custom:

```swift
        bottomSheet!.setUp(parentController: self, tableDelegate: nil, tableDataSource: nil, maxBottomSheetHeight: 0)
```

If left on automatic, upon expanding the BottomSheet to it's full mode, it will cover the entire containing view. The maxBottomSheetHeight property sets a limit to that in case you would preffer the bottomSheet would not go further up than a specific height.

### Bottom Sheet Modes

The bottom Sheet can be at any of four modes at any given time which you can get by using:
```swift
bottomSheet.getMode()
```

Modes:
FULL : The bottomSheet is fully rolled up
SUMMARY: The bottomSheet is displaying at the bottom of it's parent
HIDDEN: The bottomSheet is hidden
OTHER: This covers all other modes like when in transit



