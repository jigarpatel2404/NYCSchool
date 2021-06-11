//
//  Extensions.swift
//  20210610-JigarPatel-NYCSchools
//
//  Created by Jigar Patel on 10/06/21.
//

import Foundation
import UIKit

extension String {
    func slice(from: String, to: String) -> String? {
        
        return (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension UIColor {
    
    convenience init(hex: String) {
            let scanner = Scanner(string: hex)
            scanner.scanLocation = 0
            
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
    }
}
