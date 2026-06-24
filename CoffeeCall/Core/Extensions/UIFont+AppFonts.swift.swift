//
//  UIFont+AppFonts.swift.swift
//  CoffeeCall
//
//  Created by Rodrigo Cerqueira Reis on 17/12/25.
//

import Foundation
import UIKit

extension UIFont {

    enum AppFontName: String {
        case poppinsRegular = "Poppins-Regular"
    }
    
    static func appFont(name: AppFontName, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name.rawValue, size: size) {
            return font
        }
        print("⚠️ AVISO: Fonte '\(name.rawValue)' não encontrada. Usando System Font.")
        return .systemFont(ofSize: size, weight: .regular)
    }
}
