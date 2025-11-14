//
//  ConvertToQuill.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/12/25.
//

import Foundation
import UIKit

extension SwiftQuill {
    func convertAttributedToQuill(_ attributedText: NSAttributedString) -> QuillDoc {
        var deltas = [TextDelta]()

        // Define the full range of the string
        let fullRange = NSRange(location: 0, length: attributedText.length)

        // enumerates through each chunk with consistent attributes
        attributedText.enumerateAttributes(in: fullRange, options: []) { attributes, range, _ in
            // Get raw text
            let textChunk = attributedText.attributedSubstring(from: range).string

            guard !textChunk.isEmpty else {
                return
            }

            var deltaAttributes: [Attributes: Bool] = [:]

            // Check for Bold and Italic by inspecting the font's traits
            if let font = attributes[.font] as? UIFont {
                let traits = font.fontDescriptor.symbolicTraits

                if traits.contains(.traitBold) {
                    deltaAttributes[.bold] = true
                }
                if traits.contains(.traitItalic) {
                    deltaAttributes[.italic] = true
                }
            }

            // Check for Underline
            if
                let underlineStyle = attributes[.underlineStyle] as? Int,
                underlineStyle == NSUnderlineStyle.single.rawValue
            {
                deltaAttributes[.underline] = true
            }

            // Create the delta
            let finalAttributes = deltaAttributes.isEmpty ? nil : deltaAttributes
            let delta = TextDelta(insert: textChunk, attributes: finalAttributes)

            deltas.append(delta)
        }

        return QuillDoc(deltas: deltas)
    }
}
