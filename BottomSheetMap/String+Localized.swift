//
//  String+Localized.swift
//  BottomSheetMap
//
//  Created by George Avgoustis on 18/09/2017.
//  Copyright © 2017 Malforked. All rights reserved.
//

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.init(identifier: "com.malforked.BottomSheetMap")!, value: "", comment: "")
    }
}
