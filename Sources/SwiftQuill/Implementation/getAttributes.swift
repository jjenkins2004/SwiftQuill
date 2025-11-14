//
//  File 2.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
import UIKit

extension SwiftQuill {
    func convertToNSAttributes(_ attributes: [Attributes: Bool]?) -> [NSAttributedString.Key: Any] {
        var bold = false
        var italic = false
        var underline = false

        for attribute in Attributes.allCases {
            switch attribute {
            case .bold:
                bold = attributes?[.bold] == true
            case .italic:
                italic = attributes?[.italic] == true
            case .underline:
                underline = attributes?[.underline] == true
            }
        }

        var swiftAttributes: [NSAttributedString.Key: Any] = [:]

        // Apply fonts
        if bold, italic {
            swiftAttributes[.font] = fonts.boldItalicFont
        } else if bold {
            swiftAttributes[.font] = fonts.boldFont
        } else if italic {
            swiftAttributes[.font] = fonts.italicFont
        } else {
            swiftAttributes[.font] = fonts.baseFont
        }

        // Apply underlines
        if underline {
            swiftAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        return swiftAttributes
    }
}
