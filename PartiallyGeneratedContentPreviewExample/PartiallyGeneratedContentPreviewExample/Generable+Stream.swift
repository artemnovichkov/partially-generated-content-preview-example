//
//  Created by Artem Novichkov on 28.07.2025.
//

import FoundationModels

extension Generable {
    static func streamResponse(from json: String,
                               offsetBy distance: Int = 4,
                               delay: Duration = .milliseconds(500)) -> AsyncThrowingStream<Self.PartiallyGenerated, Error> {
        AsyncThrowingStream { continuation in
            Task {
                var index = json.startIndex
                while index < json.endIndex {
                    let nextIndex = json.index(index, offsetBy: distance, limitedBy: json.endIndex) ?? json.endIndex
                    let substring = String(json[..<nextIndex])
                    let generatedContent = try GeneratedContent(json: substring)
                    let content = try PartiallyGenerated(generatedContent)
                    continuation.yield(content)
                    index = nextIndex
                    try await Task.sleep(for: delay)
                }
                continuation.finish()
            }
        }
    }
}
