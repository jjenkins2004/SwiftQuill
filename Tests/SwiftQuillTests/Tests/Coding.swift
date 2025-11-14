//
//  Coding.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation
@testable import SwiftQuill
import Testing

@Suite("Coding")
struct Coding {
    // MARK: Internal

    @Test
    func encodeQuill() async throws {
        // Create doc
        let converter = makeConverter()
        let delta1 = TextDelta(insert: "Hello", attributes: [.bold: true])
        let delta2 = TextDelta(insert: "!", attributes: nil)
        let quillDoc = QuillDoc(deltas: [delta1, delta2])

        // Define expected JSON
        let expectedJSONString = """
        {"ops":[{"attributes":{"bold":true},"insert":"Hello"},{"insert":"!"}]}
        """

        // Encode doc
        let resultingData = try converter.encodeQuill(quillDoc)
        let resultingJSONString = String(data: resultingData, encoding: .utf8)

        // assert
        #expect(
            resultingJSONString == expectedJSONString,
            "The encoded JSON string does not match the expected format."
        )
    }

    @Test
    func decodeQuill() async throws {
        let converter = makeConverter()

        // Create JSON
        let inputJSONString = """
        {
            "ops": [
                { "insert": "Test", "attributes": { "italic": true, "underline": true } },
                { "insert": " data" }
            ]
        }
        """
        let jsonData = try #require(inputJSONString.data(using: .utf8))

        // Define the expected QuillDoc
        let expectedDelta1 = TextDelta(
            insert: "Test",
            attributes: [.italic: true, .underline: true]
        )
        let expectedDelta2 = TextDelta(insert: " data", attributes: nil)
        let expectedDoc = QuillDoc(deltas: [expectedDelta1, expectedDelta2])

        // Decode
        let resultingDoc = try converter.decodeQuill(jsonData)

        // Assert
        #expect(
            resultingDoc == expectedDoc,
            "The decoded QuillDoc does not match the expected struct."
        )
    }

    @Test
    func roundTrip() async throws {
        let converter = makeConverter()

        let originalDoc = QuillDoc(deltas: [
            TextDelta(insert: "One", attributes: [.bold: true, .italic: true]),
            TextDelta(insert: "Two", attributes: nil),
            TextDelta(insert: "Three", attributes: [.underline: true]),
        ])

        // Doc -> JSON
        let encodedData = try converter.encodeQuill(originalDoc)

        // JSON -> Doc
        let resultingDoc = try converter.decodeQuill(encodedData)

        // Assert
        #expect(
            resultingDoc == originalDoc,
            "Data was lost or corrupted during the JSON round-trip."
        )
    }

    @Test
    func decodeCorruptQuill() async throws {
        let converter = makeConverter()

        // "ops" is a string, not an array
        let badJSON_1 = #"{"ops": "this should fail"}"#.data(using: .utf8)!

        // "attributes" is a string, not an object
        let badJSON_2 = #"{"ops": [{"insert": "Hi", "attributes": "also bad"}]}"#
            .data(using: .utf8)!
        
        // Expect errors
        #expect(throws: DecodingError.self, "Decoder should fail when 'ops' is not an array") {
            _ = try converter.decodeQuill(badJSON_1)
        }
        #expect(
            throws: DecodingError.self,
            "Decoder should fail when 'attributes' is not an object"
        ) {
            _ = try converter.decodeQuill(badJSON_2)
        }
    }

    @Test
    func decodeUnknownKeys() async throws {
        let converter = makeConverter()

        // Try key that isn't supported yet
        let inputJSONString = """
        {
            "ops": [
                { "insert": "Hello", "attributes": { "bold": true, "header": 1 } }
            ]
        }
        """
        let jsonData = try #require(inputJSONString.data(using: .utf8))

        // Expected
        let expectedDoc = QuillDoc(deltas: [
            TextDelta(insert: "Hello", attributes: [.bold: true]),
        ])

        let resultingDoc = try converter.decodeQuill(jsonData)
        #expect(resultingDoc == expectedDoc)
    }

    // MARK: Private

    private func makeConverter() -> SwiftQuill {
        return SwiftQuill(fontSize: 12)
    }
}
