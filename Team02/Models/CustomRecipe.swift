import Foundation

struct CustomRecipe: Identifiable, Equatable {
    let id: UUID
    let title: String
    let creatorId: String
    var image: String?
    let instructions: String
    let ingredients: [CustomIngredient]
    let sharedWithEvents: [String]
    let isPrivate: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        creatorId: String,
        image: String? = nil,
        instructions: String,
        ingredients: [CustomIngredient],
        sharedWithEvents: [String],
        isPrivate: Bool
    ) {
        self.id = id
        self.title = title
        self.creatorId = creatorId
        self.image = image
        self.instructions = instructions
        self.ingredients = ingredients
        self.sharedWithEvents = sharedWithEvents
        self.isPrivate = isPrivate
    }
    
    func toDictionary() -> [String: Any] {
        [
            "id": id.uuidString,
            "title": title,
            "creatorId": creatorId,
            "image": image as Any,
            "instructions": instructions,
            "ingredients": ingredients.map { $0.toDictionary() },
            "sharedWithEvents": sharedWithEvents,
            "isPrivate": isPrivate
        ]
    }

    static func ==(lhs: CustomRecipe, rhs: CustomRecipe) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.creatorId == rhs.creatorId &&
               lhs.image == rhs.image &&
               lhs.instructions == rhs.instructions &&
               lhs.ingredients == rhs.ingredients &&
               lhs.sharedWithEvents == rhs.sharedWithEvents &&
               lhs.isPrivate == rhs.isPrivate
    }
}

struct CustomIngredient: Identifiable, Equatable {
    let id: UUID
    let name: String
    let amount: String
    
    func toDictionary() -> [String: Any] {
        [
            "id": id.uuidString,
            "name": name,
            "amount": amount
        ]
    }

    static func == (lhs: CustomIngredient, rhs: CustomIngredient) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.amount == rhs.amount
    }
}
