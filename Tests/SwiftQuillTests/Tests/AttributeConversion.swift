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

@Suite("Attribute Conversion")
struct AttributeConversionTests {
    // MARK: Internal

    @Test
    func nilAttributes() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [:])

        // Should just get the base font back
        #expect(nsAttrs.count == 1)
        #expect(nsAttrs[.font] as? UIFont == fonts.baseFont)
    }

    @Test
    func emptyAttributes() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [:])

        // Should also just get the base font back
        #expect(nsAttrs.count == 1)
        #expect(nsAttrs[.font] as? UIFont == fonts.baseFont)
    }

    @Test
    func boldAttribute() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [.bold: true])

        // Should get only the bold font
        #expect(nsAttrs.count == 1)
        #expect(nsAttrs[.font] as? UIFont == fonts.boldFont)
    }

    @Test
    func italicAndUnderline() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [.italic: true, .underline: true])

        // Should get the italic font and the underline style
        #expect(nsAttrs.count == 2)
        #expect(nsAttrs[.font] as? UIFont == fonts.italicFont)

        let style = nsAttrs[.underlineStyle] as? Int
        #expect(style == NSUnderlineStyle.single.rawValue)
    }

    @Test
    func boldItalic() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [.bold: true, .italic: true])

        // Should get only the bold-italic font
        #expect(nsAttrs.count == 1)
        #expect(nsAttrs[.font] as? UIFont == fonts.boldItalicFont)
    }

    @Test
    func allAttributes() throws {
        let (converter, fonts) = makeTestRig()

        let nsAttrs = converter.getNSAttributes(from: [
            .bold: true,
            .italic: true,
            .underline: true,
        ])

        // Should get the bold-italic font AND the underline style
        #expect(nsAttrs.count == 2)
        #expect(nsAttrs[.font] as? UIFont == fonts.boldItalicFont)

        let style = nsAttrs[.underlineStyle] as? Int
        #expect(style == NSUnderlineStyle.single.rawValue)
    }

    // MARK: Private

    private func makeTestRig() -> (converter: SwiftQuill, fonts: UIFonts) {
        let converter = SwiftQuill(fontSize: 12)
        return (converter, converter.fonts)
    }
}
