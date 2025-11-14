//
//  ConvertToAttributed.swift
//  SwiftQuill
//
//  Created by Joshua Jenkins on 11/12/25.
//

import Foundation
import UIKit

extension SwiftQuill {
    func convertQuillToAttributed(
        _ doc: QuillDoc,
    )
        -> NSAttributedString
    {
        let finalString = NSMutableAttributedString()

        for delta in doc.ops {
            guard let text = delta.insert else {
                continue
            }

            let attributes = convertToNSAttributes(delta.attributes)

            // Add the string chunk
            let attributedChunk = NSAttributedString(string: text, attributes: attributes)
            finalString.append(attributedChunk)
        }

        return finalString
    }
}
