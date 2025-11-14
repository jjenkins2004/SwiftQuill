//
//  Types.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/12/25.
//

import Foundation
import UIKit

// MARK: - QuillDoc

public struct QuillDoc: Codable, Equatable {
    // MARK: Lifecycle

    public init(deltas: [TextDelta]) {
        ops = deltas
    }

    // MARK: Public

    public let ops: [TextDelta]
}

// MARK: - TextDelta

public struct TextDelta: Codable, Equatable {
    // MARK: Lifecycle

    public init(insert: String, attributes: [Attributes: Bool]?) {
        self.insert = insert
        self.attributes = attributes
    }

    // MARK: Public

    public let insert: String?
    public let attributes: [Attributes: Bool]?
}

// MARK: - Attributes

public enum Attributes: String, Codable, Equatable, CaseIterable {
    case bold
    case italic
    case underline
}

// MARK: - AttributeType

enum AttributeType: Codable, Equatable {
    case bool(Bool)
    case int(Int)
    case string(String)

    // MARK: Lifecycle

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let val = try? container.decode(Bool.self) {
            self = .bool(val)
        } else if let val = try? container.decode(Int.self) {
            self = .int(val)
        } else if let val = try? container.decode(String.self) {
            self = .string(val)
        } else {
            throw DecodingError.typeMismatch(
                AttributeType.self,
                .init(
                    codingPath: decoder.codingPath,
                    debugDescription: "Attribute value was not a known type"
                )
            )
        }
    }

    // MARK: Internal

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .bool(val): try container.encode(val)
        case let .int(val): try container.encode(val)
        case let .string(val): try container.encode(val)
        }
    }
}
