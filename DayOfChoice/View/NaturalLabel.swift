//
//  NaturalLabel.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/05/21.
//

import UIKit
import NaturalLanguage

class NaturalLabel: UILabel {
    func naturalize() {
        guard let text = self.text?.replacingOccurrences(of: "\n", with: "") else { return }
        
        let tokenizer = NLTokenizer(unit: .word)
        tokenizer.string = text
        
        let tokens = tokenizer.tokens(for: text.startIndex..<text.endIndex)
        let words = tokens.map({ String(text[$0]) })
        
        print("words", words)
        guard words.count > 1 else { return }
        
        var fixedLines = [String]()
        var fixedTokens = 0
        
        while fixedTokens < tokens.count {
            let remainingTokens = tokens.dropFirst(fixedTokens)
            let remainingText = String(text[remainingTokens.first!.lowerBound...])
            let remainingLines = self.getLines(from: remainingText)
            
            guard let brokenToken = remainingTokens.first(where: {
                let word = text[$0]
                return !remainingLines.contains(where: { $0.contains(word) })
            }) else {
                fixedLines += [remainingText]
                fixedTokens += remainingTokens.count
                continue
            }
            
            fixedLines += [String(text[remainingTokens.first!.lowerBound..<brokenToken.lowerBound])]
            fixedTokens = remainingTokens.firstIndex(of: brokenToken)!
        }
        
        self.text = fixedLines.joined(separator: "\n")
    }
    
    private func getLines(from text: String) -> [String] {
        guard let font = self.font else { return [] }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.font, value: font, range: NSRange(location: 0, length: attributedString.length))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        let framePath = CGPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat.greatestFiniteMagnitude), transform: nil)
        let frame = CTFramesetterCreateFrame(frameSetter, CFRange(), framePath, nil)
        
        guard let lines = CTFrameGetLines(frame) as? [CTLine] else { return [] }
        return lines.map({ line in
            let cfRange = CTLineGetStringRange(line)
            let nsRange = NSRange(location: cfRange.location, length: cfRange.length)
            return NSString(string: text).substring(with: nsRange)
        })
    }
}

