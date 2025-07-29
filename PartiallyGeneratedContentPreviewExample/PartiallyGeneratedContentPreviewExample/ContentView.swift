//
//  Created by Artem Novichkov on 28.07.2025.
//

import SwiftUI
import FoundationModels

struct ContentView: View {
    @State private var session = LanguageModelSession()
    @State private var catProfile: CatProfile.PartiallyGenerated?

    var body: some View {
        NavigationStack {
            List {
                if let catProfile {
                    CatProfileView(catProfile: catProfile)
                }
            }
            .navigationTitle("Cat Profile")
            .task {
                do {
                    let stream = session.streamResponse(generating: CatProfile.self) {
                        "Generate a cute rescue cat"
                    }
                    for try await catProfile in stream {
                        self.catProfile = catProfile
                    }
                } catch {
                    print("Error generating cat profile: \(error)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
