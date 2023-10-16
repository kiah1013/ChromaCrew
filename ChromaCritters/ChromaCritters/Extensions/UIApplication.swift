//
//  UIApplication.swift
//  ChromaCritters
//
//  Created by Daniel Youssef on 10/13/23.
//

import Foundation
import SwiftUI

// Used for dismissing the keyboard in the SearchBarView
extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
