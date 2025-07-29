//
//  Created by Artem Novichkov on 28.07.2025.
//

import FoundationModels

@Generable(description: "Basic profile information about a cat")
struct CatProfile: Equatable {
    let name: String

    @Guide(description: "A one sentence profile about the cat's personality")
    let profile: String

    @Guide(description: "The age of the cat", .range(0...20))
    let age: Int
}

extension CatProfile {
    static let mock = CatProfile(name: "Trisha",
                                 profile: "A playful and curious cat who loves to explore her surroundings.",
                                 age: 8)
}
