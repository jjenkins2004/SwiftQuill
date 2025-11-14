//
//  File.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
@testable import SwiftQuill
import Testing
import UIKit

func assertAttributes(
    with expectedAttributes: [Attributes: Bool],
    size: CGFloat,
    in attributes: [NSAttributedString.Key: Any]
) {
    var bold = false
    var italic = false
    var underline = false

    for (attribute, active) in expectedAttributes {
        switch attribute {
        case .bold:
            bold = active
        case .italic:
            italic = active
        case .underline:
            underline = active
        }
    }

    let font = attributes[.font] as? UIFont
    #expect(font != nil, "NSAttributedString is missing the .font attribute.")
    #expect(font?.pointSize == size, "Font size mismatch. Expected \(size), but got \(font?.pointSize ?? 0).")
    
    for attribute in Attributes.allCases {
        switch attribute {
        case .bold:
            #expect(font?.isBold == bold)
        case .italic:
            #expect(font?.isItalic == italic)
        case .underline:
            if underline {
                #expect(attributes[.underlineStyle] as? Int == 1)
            } else {
                let style = attributes[.underlineStyle] as? Int
                #expect(style == nil || style == 0, "Expected no underline (nil or 0)")
            }
        }
    }
}
