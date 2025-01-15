import Foundation

class ArtworkManager: ObservableObject {
    static let shared = ArtworkManager()
    
    @Published private(set) var pieces: [ArtPiece] = []
    @Published private(set) var galleries: [Gallery] = []
    
    private init() {
        loadData()
    }
    
    // MARK: - Art Piece Management
    
    func addPiece(_ piece: ArtPiece) {
        // Check if piece already exists to avoid duplicates
        if !pieces.contains(where: { $0.id == piece.id }) {
            pieces.append(piece)
            savePieces()
        }
    }
    
    func removePiece(_ piece: ArtPiece) {
        pieces.removeAll { $0.id == piece.id }
        savePieces()
    }
    
    // MARK: - Gallery Management
    
    func addGallery(_ gallery: Gallery) {
        galleries.append(gallery)
        saveGalleries()
    }
    
    func updateGallery(_ gallery: Gallery) {
        if let index = galleries.firstIndex(where: { $0.id == gallery.id }) {
            galleries[index] = gallery
            saveGalleries()
        }
    }
    
    func removeGallery(_ gallery: Gallery) {
        galleries.removeAll { $0.id == gallery.id }
        saveGalleries()
    }
    
    func reorderGalleries(from source: IndexSet, to destination: Int) {
        galleries.move(fromOffsets: source, toOffset: destination)
        saveGalleries()
    }
    
    // MARK: - Data Persistence
    
    private func savePieces() {
        do {
            let piecesData = try JSONEncoder().encode(pieces)
            UserDefaults.standard.set(piecesData, forKey: "artPieces")
        } catch {
            print("Error saving pieces: \(error)")
        }
    }
    
    private func saveGalleries() {
        do {
            let galleriesData = try JSONEncoder().encode(galleries)
            UserDefaults.standard.set(galleriesData, forKey: "galleries")
        } catch {
            print("Error saving galleries: \(error)")
        }
    }
    
    private func loadData() {
        if let piecesData = UserDefaults.standard.data(forKey: "artPieces") {
            do {
                pieces = try JSONDecoder().decode([ArtPiece].self, from: piecesData)
            } catch {
                print("Error loading pieces: \(error)")
            }
        }
        
        if let galleriesData = UserDefaults.standard.data(forKey: "galleries") {
            do {
                galleries = try JSONDecoder().decode([Gallery].self, from: galleriesData)
            } catch {
                print("Error loading galleries: \(error)")
            }
        }
    }
    
    func resetAllData() {
        self.galleries = []
        self.pieces = []
        UserDefaults.standard.removeObject(forKey: "artPieces")
        UserDefaults.standard.removeObject(forKey: "galleries")
        savePieces()
        saveGalleries()
    }
}
