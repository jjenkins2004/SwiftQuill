// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UIKit

// MARK: - SwiftQuill

public class SwiftQuill {
    public init(fontSize: CGFloat) {
        self.fontSize = fontSize
        let baseFont = UIFont.systemFont(ofSize: fontSize)
        fonts = UIFonts(baseFont: baseFont)
    }

    public let fontSize: CGFloat
    public let fonts: UIFonts

    public func convertToQuill(_ attributedText: NSAttributedString) throws -> QuillDoc {
        convertAttributedToQuill(attributedText)
    }

    public func convertToAttributed(_ doc: QuillDoc) -> NSAttributedString {
        convertQuillToAttributed(doc)
    }

    public func encodeQuill(_ doc: QuillDoc) throws -> Data {
        try encodeQuillDoc(doc)
    }

    public func decodeQuill(_ data: Data) throws -> QuillDoc {
        try decodeQuillDoc(data)
    }

    public func getNSAttributes(from attributes: [Attributes: Bool]) -> [NSAttributedString.Key: Any] {
        return convertToNSAttributes(attributes)
    }
}
