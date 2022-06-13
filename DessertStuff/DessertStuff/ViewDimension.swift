//
//  ViewDimension.swift
//  DessertStuff
//
//  Created by Chan Jung on 6/13/22.
//

import Foundation
import SwiftUI

struct ScreenDimension {
    static let width: CGFloat = UIScreen.main.bounds.width
    static let height: CGFloat = UIScreen.main.bounds.height
}

struct Constants {
    static let cornerSmall: CGFloat = 5
    static let cornerMedium: CGFloat = 8
    static let cornerlarge: CGFloat = 12
    
    static let shadowSmall: CGFloat = 5
    static let shadowMedium: CGFloat = 8
    static let shadowlarge: CGFloat = 12
    
    static let paddingSmall: CGFloat = 3
    static let paddingMedium: CGFloat = 6
    static let paddingLarge: CGFloat = 8
    
    static let buttonSizeSmall: CGFloat = 15
    static let buttonSizeMedium: CGFloat = 30
    static let buttonSizeLarge: CGFloat = 10
}
