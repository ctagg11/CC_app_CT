import SwiftUI

struct GallerySelector: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var artworkManager = ArtworkManager.shared
    let piece: ArtPiece
    @Binding var selectedGallery: Gallery?
    
    @State private var showNewGallerySheet = false
    @State private var newGalleryName = ""
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        showNewGallerySheet = true
                    }) {
                        Label("Create New Gallery", systemImage: "plus.circle")
                    }
                    
                    if !artworkManager.galleries.isEmpty {
                        Button(action: {}) {
                            Label("Add to Existing Gallery", systemImage: "folder.badge.plus")
                        }
                    } else {
                        Label("Add to Existing Gallery", systemImage: "folder.badge.plus")
                            .foregroundColor(.gray)
                    }
                }
                
                if !artworkManager.galleries.isEmpty {
                    Section("Existing Galleries") {
                        ForEach(artworkManager.galleries) { gallery in
                            Button(action: {
                                selectedGallery = gallery
                                dismiss()
                            }) {
                                Text(gallery.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showNewGallerySheet) {
                NewGallerySheet(galleryName: $newGalleryName) { name in
                    let newGallery = Gallery(name: name)
                    artworkManager.addGallery(newGallery)
                    selectedGallery = newGallery
                    dismiss()
                }
            }
        }
    }
    
    private func addToGallery(_ gallery: Gallery) {
        // First save the piece to ArtworkManager
        artworkManager.addPiece(piece)
        
        // Then update the gallery with the piece
        var updatedGallery = gallery
        updatedGallery.addPiece(piece)
        artworkManager.updateGallery(updatedGallery)
        dismiss()
    }
    
    private func createAndAddToNewGallery(_ name: String) {
        // First save the piece to ArtworkManager
        artworkManager.addPiece(piece)
        
        // Then create and update the gallery
        var newGallery = Gallery(name: name)
        newGallery.addPiece(piece)
        artworkManager.addGallery(newGallery)
        dismiss()
    }
}

struct NewGallerySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var galleryName: String
    let onCreate: (String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Gallery Name", text: $galleryName)
            }
            .navigationTitle("New Gallery")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        onCreate(galleryName)
                        dismiss()
                    }
                    .disabled(galleryName.isEmpty)
                }
            }
        }
    }
}
