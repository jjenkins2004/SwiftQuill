//
//  File.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
import UIKit

struct UIFonts {
    // MARK: Lifecycle

    init(baseFont: UIFont) {
        self.baseFont = baseFont

        // Bold Font
        boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)!
        boldFont = UIFont(
            descriptor: boldDescriptor,
            size: baseFont.pointSize
        )

        // Italic Font
        italicDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitItalic)!
        italicFont = UIFont(
            descriptor: italicDescriptor,
            size: baseFont.pointSize
        )

        // Bold Italic Font
        boldItalicDescriptor = baseFont.fontDescriptor.withSymbolicTraits([
            .traitBold,
            .traitItalic,
        ])!
        boldItalicFont = UIFont(
            descriptor: boldItalicDescriptor,
            size: baseFont.pointSize
        )
    }

    // MARK: Internal

    let baseFont: UIFont
    let boldFont: UIFont
    let boldDescriptor: UIFontDescriptor
    let italicFont: UIFont
    let italicDescriptor: UIFontDescriptor
    let boldItalicFont: UIFont
    let boldItalicDescriptor: UIFontDescriptor
    let underlineStyle = NSUnderlineStyle.single.rawValue
}
