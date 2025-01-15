import Foundation

struct Gallery: Identifiable, Codable {
    var id = UUID()
    var name: String
    var creationDate: Date
    var pieceIDs: Set<UUID>
    
    init(name: String) {
        self.name = name
        self.creationDate = Date()
        self.pieceIDs = Set<UUID>()
    }
    
    mutating func addPiece(_ piece: ArtPiece) {
        pieceIDs.insert(piece.id)
    }
    
    mutating func removePiece(_ piece: ArtPiece) {
        pieceIDs.remove(piece.id)
    }
}
