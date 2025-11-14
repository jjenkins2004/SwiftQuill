//
//  Encoder.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation

func encodeQuillDoc(_ doc: QuillDoc) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = .sortedKeys
    return try encoder.encode(doc)
}
