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
        let boldDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitBold)
        boldFont = UIFont(
            descriptor: boldDescriptor ?? baseFont.fontDescriptor,
            size: baseFont.pointSize
        )

        // Italic Font
        let italicDescriptor = baseFont.fontDescriptor.withSymbolicTraits(.traitItalic)
        italicFont = UIFont(
            descriptor: italicDescriptor ?? baseFont.fontDescriptor,
            size: baseFont.pointSize
        )

        // Bold Italic Font
        let boldItalicDescriptor = baseFont.fontDescriptor.withSymbolicTraits([
            .traitBold,
            .traitItalic,
        ])
        boldItalicFont = UIFont(
            descriptor: boldItalicDescriptor ?? baseFont.fontDescriptor,
            size: baseFont.pointSize
        )
    }

    // MARK: Internal

    let baseFont: UIFont
    let boldFont: UIFont
    let italicFont: UIFont
    let boldItalicFont: UIFont
}
