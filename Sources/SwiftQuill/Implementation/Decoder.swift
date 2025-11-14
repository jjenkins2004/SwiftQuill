//
//  Decoder.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/13/25.
//

import Foundation

func decodeQuillDoc(_ data: Data) throws -> QuillDoc {
    let decoder = JSONDecoder()
    return try decoder.decode(QuillDoc.self, from: data)
}
