//
//  AttributedToQuill.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
@testable import SwiftQuill
import Testing

@Suite("Attributed To Quill")
struct AttributedToQuill {
    // MARK: Internal

    @Test
    func basicDocToAttributedStringConversion() async throws {
        let fontSize: CGFloat = 12
        let converter = SwiftQuill(fontSize: fontSize)

        // Create quillDoc
        let delta1 = TextDelta(insert: "Hello", attributes: [.bold: true])
        let delta2 = TextDelta(insert: " ", attributes: nil)
        let delta3 = TextDelta(insert: "World", attributes: [.italic: true, .underline: true])
        let quillDoc = QuillDoc(deltas: [delta1, delta2, delta3])

        // Convert
        let attributedString = converter.convertToAttributed(quillDoc)

        // Check
        #expect(attributedString.string == "Hello World", "The final plain string is incorrect.")

        // Define all expectations
        let expectedRuns: [ExpectedRun] = [
            .init(location: 0, length: 5, attributes: [.bold: true], comment: "Bolded 'Hello'"),
            .init(location: 5, length: 1, attributes: [:], comment: "No attribute ' '"),
            .init(
                location: 6,
                length: 5,
                attributes: [.italic: true, .underline: true],
                comment: "Italic/underlined 'World'"
            ),
        ]

        // Loop through and assert each one
        for run in expectedRuns {
            assertRun(in: attributedString, expected: run, fontSize: fontSize)
        }
    }

    @Test
    func comprehensiveDocToAttributedStringConversion() async throws {
        let fontSize: CGFloat = 12
        let converter = SwiftQuill(fontSize: fontSize)

        // Create quillDoc
        let delta1 = TextDelta(insert: "Plain text. ", attributes: nil)
        let delta2 = TextDelta(
            insert: "All three! ",
            attributes: [.bold: true, .italic: true, .underline: true]
        )
        let delta3 = TextDelta(insert: "Just italic. ", attributes: [.italic: true])
        let delta4 = TextDelta(insert: "Just underline. ", attributes: [.underline: true])
        let delta5 = TextDelta(insert: "Done.", attributes: nil)
        let quillDoc = QuillDoc(deltas: [delta1, delta2, delta3, delta4, delta5])

        // Convert
        let attributedString = converter.convertToAttributed(quillDoc)

        // Check
        #expect(
            attributedString.string == "Plain text. All three! Just italic. Just underline. Done.",
            "The final plain string is incorrect."
        )

        // Define expectations
        let expectedRuns: [ExpectedRun] = [
            .init(location: 0, length: 12, attributes: [:], comment: "Plain text. "),
            .init(
                location: 12,
                length: 11,
                attributes: [.bold: true, .italic: true, .underline: true],
                comment: "All three! "
            ),
            .init(location: 23, length: 13, attributes: [.italic: true], comment: "Just italic. "),
            .init(
                location: 36,
                length: 16,
                attributes: [.underline: true],
                comment: "Just underline. "
            ),
            .init(location: 52, length: 5, attributes: [:], comment: "Done."),
        ]

        // Loop through and assert each one
        for run in expectedRuns {
            assertRun(in: attributedString, expected: run, fontSize: fontSize)
        }
    }

    @Test
    func testEmptyDoc() throws {
        let converter = SwiftQuill(fontSize: 12)
        let emptyDoc = QuillDoc(deltas: [])

        let attributedString = converter.convertToAttributed(emptyDoc)

        #expect(attributedString.string.isEmpty)
        #expect(attributedString.length == 0)
    }

    private func assertRun(
        in attributedString: NSAttributedString,
        expected: ExpectedRun,
        fontSize: CGFloat
    ) {
        var range = NSRange()

        let nsAttributes = attributedString.attributes(
            at: expected.location,
            effectiveRange: &range
        )
        let expectedRange = NSRange(location: expected.location, length: expected.length)
        #expect(
            range == expectedRange,
            "Range for '\(expected.comment)' is wrong. Expected \(expectedRange), got \(range)"
        )
        assertAttributes(with: expected.attributes, size: fontSize, in: nsAttributes)
    }

    // MARK: Private

    private struct ExpectedRun {
        let location: Int
        let length: Int
        let attributes: [Attributes: Bool]
        let comment: String // For better error messages
    }
}
