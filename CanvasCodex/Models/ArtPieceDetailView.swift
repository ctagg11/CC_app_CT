import SwiftUI

struct ArtPieceDetailView: View {
    let piece: ArtPiece
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let uiImage = UIImage(data: piece.imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(piece.title)
                        .font(.title)
                        .bold()
                    
                    if let medium = piece.medium {
                        Text("Medium: \(medium)")
                            .font(.body)
                    }
                    
                    if let dimensions = piece.dimensions {
                        Text("Dimensions: \(dimensions)")
                            .font(.body)
                    }
                    
                    if let notes = piece.notes {
                        Text("Notes:")
                            .font(.headline)
                            .padding(.top, 8)
                        Text(notes)
                            .font(.body)
                    }
                    
                    Text("Created: \(piece.uploadDate.formatted())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

