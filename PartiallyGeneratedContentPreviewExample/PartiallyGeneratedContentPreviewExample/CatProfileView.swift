//
//  Created by Artem Novichkov on 28.07.2025.
//

import SwiftUI
import FoundationModels
import Playgrounds

struct CatProfileView: View {
    let catProfile: CatProfile.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading) {
            if let name = catProfile.name {
                Text(name)
                    .font(.headline)
                    .transition(.opacity)
            }
            if let profile = catProfile.profile {
                Text(profile)
                    .font(.subheadline)
                    .transition(.opacity)
            }
            if let age = catProfile.age {
                Text("Age: \(age)")
                    .font(.caption)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: catProfile)
    }
}

#Preview("Mock", traits: .sizeThatFitsLayout) {
    CatProfileView(catProfile: CatProfile.mock.asPartiallyGenerated())
}

#Preview("GeneratedContent", traits: .sizeThatFitsLayout) {
    let jsons = [
        #"{"name": "Trisha"#,
        #"{"name": "Trisha", "profile": "A playful and curious cat"#,
        #"{"name": "Trisha", "profile": "A playful and curious cat", "age": 8"#,
    ]
    VStack(spacing: 8) {
        ForEach(jsons, id: \.self) { json in
            let content = try! GeneratedContent(json: json)
            CatProfileView(catProfile: try! .init(content))
        }
    }
}

#Playground {
    let json = #"{"name": "Trisha", "profile": "A playful and curious cat", "age": 8}"#
    for try await catProfile in CatProfile.streamResponse(from: json) {
        print(catProfile)
    }
}

private struct WrapperView: View {
    @State private var catProfile: CatProfile.PartiallyGenerated?

    var body: some View {
        ZStack {
            if let catProfile {
                CatProfileView(catProfile: catProfile)
            }
        }
        .task {
            do {
                let json = #"{"name": "Trisha", "profile": "A lovely cat", "age": 8}"#
                for try await catProfile in CatProfile.streamResponse(from: json) {
                    self.catProfile = catProfile
                }
            } catch {
                print("Error generating cat profile: \(error)")
            }
        }
    }
}

#Preview("Stream") {
    WrapperView()
}
