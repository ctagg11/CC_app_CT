import Foundation

struct ArtPiece: Identifiable, Codable {
    // Required properties
    let id: UUID
    var title: String
    var dateStarted: Date?
    var dateCompleted: Date?
    var medium: String?
    var dimensions: String?
    var imageData: Data
    var uploadDate: Date
    
    // Optional properties
    var inspiration: String?
    var notes: String?
    
    // Gallery relationships
    var galleryIDs: Set<UUID>
    
    // Initialization with default values
    init(
        title: String,
        dateStarted: Date? = nil,
        dateCompleted: Date? = nil,
        medium: String? = nil,
        dimensions: String? = nil,
        imageData: Data,
        inspiration: String? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.dateStarted = dateStarted
        self.dateCompleted = dateCompleted
        self.medium = medium
        self.dimensions = dimensions
        self.imageData = imageData
        self.inspiration = inspiration
        self.notes = notes
        self.uploadDate = Date()
        self.galleryIDs = Set<UUID>()
    }
}
