import SwiftUI

struct NewArtworkForm: View {
    let scannedImage: UIImage
    @Environment(\.dismiss) private var dismiss
    @StateObject private var artworkManager = ArtworkManager.shared
    
    @State private var title = "New Artwork"
    @State private var dateStarted: Date?
    @State private var dateCompleted: Date?
    @State private var medium = ""
    @State private var height = ""
    @State private var width = ""
    @State private var depth = ""
    @State private var dimensionUnit = "cm"
    @State private var inspiration = ""
    @State private var notes = ""
    @State private var showGallerySelector = false
    @State private var selectedGallery: Gallery?
    
    private var isFormValid: Bool {
        !title.isEmpty
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Image(uiImage: scannedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                }
                
                Section {
                    TextField("Name your piece*", text: $title)
                }
                
                Section {
                    Toggle("Add dates", isOn: Binding(
                        get: { dateStarted != nil },
                        set: { if !$0 { dateStarted = nil; dateCompleted = nil } else { dateStarted = Date(); dateCompleted = Date() } }
                    ))
                    
                    if dateStarted != nil {
                        DatePicker("Date Started", selection: Binding(
                            get: { dateStarted ?? Date() },
                            set: { dateStarted = $0 }
                        ), displayedComponents: .date)
                        DatePicker("Date Completed", selection: Binding(
                            get: { dateCompleted ?? Date() },
                            set: { dateCompleted = $0 }
                        ), displayedComponents: .date)
                    }
                }
                
                Section {
                    TextField("Medium (optional)", text: $medium)
                }
                
                Section(header: Text("Dimensions (optional)")) {
                    HStack {
                        TextField("H", text: $height)
                            .keyboardType(.decimalPad)
                        TextField("W", text: $width)
                            .keyboardType(.decimalPad)
                        TextField("D", text: $depth)
                            .keyboardType(.decimalPad)
                        Picker("Unit", selection: $dimensionUnit) {
                            Text("cm").tag("cm")
                            Text("in").tag("in")
                        }
                    }
                }
                
                Section {
                    TextField("Inspiration (optional)", text: $inspiration, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    TextField("Additional notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section {
                    if let gallery = selectedGallery {
                        HStack {
                            Text("Selected Gallery: \(gallery.name)")
                            Spacer()
                            Button("Change") {
                                showGallerySelector = true
                            }
                            .foregroundColor(.blue)
                        }
                    } else {
                        Button("Add to Gallery") {
                            showGallerySelector = true
                        }
                    }
                }
                
                Button("Publish Piece") {
                    savePiece()
                }
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .padding()
                .background(isFormValid ? Color.blue : Color.gray)
                .cornerRadius(10)
                .disabled(!isFormValid)
            }
            .navigationTitle("New Artwork")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Discard") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showGallerySelector) {
            let piece = createPiece()
            GallerySelector(piece: piece, selectedGallery: $selectedGallery)
        }
    }
    
    private func createPiece() -> ArtPiece {
        let dimensions = height.isEmpty && width.isEmpty && depth.isEmpty ? nil : "\(height)x\(width)x\(depth) \(dimensionUnit)"
        let imageData = scannedImage.jpegData(compressionQuality: 0.8) ?? Data()
        
        return ArtPiece(
            title: title,
            dateStarted: dateStarted,
            dateCompleted: dateCompleted,
            medium: medium.isEmpty ? nil : medium,
            dimensions: dimensions,
            imageData: imageData,
            inspiration: inspiration.isEmpty ? nil : inspiration,
            notes: notes.isEmpty ? nil : notes
        )
    }
    
    private func savePiece() {
        let piece = createPiece()
        artworkManager.addPiece(piece)
        
        if let gallery = selectedGallery {
            var updatedGallery = gallery
            updatedGallery.addPiece(piece)
            artworkManager.updateGallery(updatedGallery)
        }
        
        dismiss()
    }
}
