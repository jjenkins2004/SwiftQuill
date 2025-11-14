//
//  QuillToAttributed.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
@testable import SwiftQuill
import Testing
import UIKit

@Suite("Quill To Attributed")
struct QuillToAttributed {
    @Test
    func basicAttributedStringToDocConversion() async throws {
        let fontSize: CGFloat = 12
        let converter = SwiftQuill(fontSize: fontSize)

        // Create the attributed string
        let fonts = UIFonts(baseFont: UIFont.systemFont(ofSize: fontSize))

        let inputString = NSMutableAttributedString()
        inputString.append(NSAttributedString(
            string: "Hello",
            attributes: [.font: fonts.boldFont] // "Hello" is bold
        ))
        inputString.append(NSAttributedString(
            string: " ",
            attributes: [.font: fonts.baseFont] // " " is plain
        ))
        inputString.append(NSAttributedString(
            string: "World",
            attributes: [
                .font: fonts.italicFont, // "World" is italic
                .underlineStyle: NSUnderlineStyle.single.rawValue, // and underlined
            ]
        ))

        // Create expected QuillDoc
        let expectedDelta1 = TextDelta(insert: "Hello", attributes: [.bold: true])
        let expectedDelta2 = TextDelta(insert: " ", attributes: nil)
        let expectedDelta3 = TextDelta(
            insert: "World",
            attributes: [.italic: true, .underline: true]
        )
        let expectedDoc = QuillDoc(deltas: [expectedDelta1, expectedDelta2, expectedDelta3])

        let resultingDoc = try converter.convertToQuill(inputString)

        // Assert Equality
        #expect(resultingDoc == expectedDoc, "The parsed deltas did not match the expected deltas.")
    }
    
    @Test
    func comprehensiveAttributedStringToDocConversion() async throws {
        let fontSize: CGFloat = 12
        let converter = SwiftQuill(fontSize: fontSize)

        // Create the attributed string
        let fonts = UIFonts(baseFont: UIFont.systemFont(ofSize: fontSize))

        let inputString = NSMutableAttributedString()

        inputString.append(NSAttributedString(
            string: "Plain. ",
            attributes: [.font: fonts.baseFont]
        ))
        
        inputString.append(NSAttributedString(
            string: "B. ",
            attributes: [.font: fonts.boldFont]
        ))
        
        inputString.append(NSAttributedString(
            string: "I. ",
            attributes: [.font: fonts.italicFont]
        ))
        
        inputString.append(NSAttributedString(
            string: "U. ",
            attributes: [
                .font: fonts.baseFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        ))
        
        inputString.append(NSAttributedString(
            string: "BI. ",
            attributes: [.font: fonts.boldItalicFont]
        ))
        
        inputString.append(NSAttributedString(
            string: "BU. ",
            attributes: [
                .font: fonts.boldFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        ))
        
        inputString.append(NSAttributedString(
            string: "IU. ",
            attributes: [
                .font: fonts.italicFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        ))
        
        inputString.append(NSAttributedString(
            string: "BIU.",
            attributes: [
                .font: fonts.boldItalicFont,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        ))

        // Create expected QuillDoc
        let expectedDelta1 = TextDelta(insert: "Plain. ", attributes: nil)
        let expectedDelta2 = TextDelta(insert: "B. ", attributes: [.bold: true])
        let expectedDelta3 = TextDelta(insert: "I. ", attributes: [.italic: true])
        let expectedDelta4 = TextDelta(insert: "U. ", attributes: [.underline: true])
        let expectedDelta5 = TextDelta(insert: "BI. ", attributes: [.bold: true, .italic: true])
        let expectedDelta6 = TextDelta(insert: "BU. ", attributes: [.bold: true, .underline: true])
        let expectedDelta7 = TextDelta(insert: "IU. ", attributes: [.italic: true, .underline: true])
        let expectedDelta8 = TextDelta(insert: "BIU.", attributes: [.bold: true, .italic: true, .underline: true])
        
        let expectedDoc = QuillDoc(deltas: [
            expectedDelta1, expectedDelta2, expectedDelta3, expectedDelta4, expectedDelta5, expectedDelta6, expectedDelta7, expectedDelta8
        ])

        let resultingDoc = try converter.convertToQuill(inputString)

        // Assert Equality
        #expect(resultingDoc == expectedDoc, "The parsed deltas did not match all permutations.")
    }
    
    @Test
    func emojiConversion() async throws {
        let fontSize: CGFloat = 12
        let converter = SwiftQuill(fontSize: fontSize)

        // Create the attributed string
        let fonts = UIFonts(baseFont: UIFont.systemFont(ofSize: fontSize))

        let inputString = NSMutableAttributedString()

        // A plain text intro
        inputString.append(NSAttributedString(
            string: "Hello ",
            attributes: [.font: fonts.baseFont]
        ))
        
        // A bold emoji
        inputString.append(NSAttributedString(
            string: "👋", // This is the key test
            attributes: [.font: fonts.boldFont]
        ))
        
        // A plain emoji, to test boundaries
        inputString.append(NSAttributedString(
            string: "🚀",
            attributes: [.font: fonts.baseFont]
        ))

        // Create expected QuillDoc
        let expectedDelta1 = TextDelta(insert: "Hello ", attributes: nil)
        let expectedDelta2 = TextDelta(insert: "👋", attributes: [.bold: true])
        let expectedDelta3 = TextDelta(insert: "🚀", attributes: nil)
        
        let expectedDoc = QuillDoc(deltas: [expectedDelta1, expectedDelta2, expectedDelta3])

        let resultingDoc = try converter.convertToQuill(inputString)

        // Assert Equality
        #expect(resultingDoc == expectedDoc, "The parsed deltas did not correctly handle emojis.")
    }

    @Test
    func testEmptyString() throws {
        let converter = SwiftQuill(fontSize: 12)
        let emptyString = NSAttributedString(string: "")
        let expectedDoc = QuillDoc(deltas: [])

        let doc = try converter.convertToQuill(emptyString)

        #expect(doc == expectedDoc)
    }
}
