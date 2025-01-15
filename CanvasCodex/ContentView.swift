//
//  ContentView.swift
//  CanvasCodex
//
//  Created by Charles Taggart on 1/13/25.
//

//
//  ContentView.swift
//  L2Demo
//
//  Created by Charles Taggart on 1/11/25.
//

import SwiftUI
import AVFoundation
import Vision
import CoreImage
import WeScan

struct ArtworkCaptureFlow: View {
    @Environment(\.dismiss) private var dismiss
    @State private var scannedImage: UIImage?
    @State private var showingScanner = true
    
    var body: some View {
        Group {
            if showingScanner {
                ScannerView(scannedImage: $scannedImage, isShowing: $showingScanner)
            } else if let image = scannedImage {
                NewArtworkForm(scannedImage: image)
            }
        }
    }
}

struct ScannerView: UIViewControllerRepresentable {
    @Binding var scannedImage: UIImage?
    @Binding var isShowing: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> ImageScannerController {
        let scanner = ImageScannerController()
        scanner.imageScannerDelegate = context.coordinator
        scanner.modalPresentationStyle = .fullScreen
        return scanner
    }
    
    func updateUIViewController(_ uiViewController: ImageScannerController, context: Context) {}
    
    class Coordinator: NSObject, ImageScannerControllerDelegate {
        let parent: ScannerView
        
        init(_ parent: ScannerView) {
            self.parent = parent
        }
        
        func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
            parent.scannedImage = results.croppedScan.image
            parent.isShowing = false
        }
        
        func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
            scanner.dismiss(animated: true)
        }
        
        func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
            print(error.localizedDescription)
        }
    }
}

struct GalleriesView: View {
    @StateObject private var artworkManager = ArtworkManager.shared
    @State private var showingCaptureFlow = false
    @State private var isEditingGalleries = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(artworkManager.galleries) { gallery in
                        VStack(alignment: .leading) {
                            Text(gallery.name)
                                .font(.title2)
                                .bold()
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                LazyHStack(spacing: 20) {
                                    ForEach(artworkManager.pieces.filter { piece in
                                        return gallery.pieceIDs.contains(piece.id)
                                    }) { piece in
                                        NavigationLink(destination: ArtPieceDetailView(piece: piece)) {
                                            VStack(alignment: .leading) {
                                                if let uiImage = UIImage(data: piece.imageData) {
                                                    Image(uiImage: uiImage)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 250)
                                                        .cornerRadius(8)
                                                        .shadow(radius: 3)
                                                }
                                                
                                                Text(piece.title)
                                                    .font(.subheadline)
                                                    .bold()
                                                    .foregroundColor(.primary)
                                                    .lineLimit(1)
                                                    .padding(.top, 4)
                                                
                                                if let medium = piece.medium {
                                                    Text(medium)
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                        .lineLimit(1)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 300)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("Galleries")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(isEditingGalleries ? "Done" : "Edit") {
                        isEditingGalleries.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCaptureFlow = true
                    }) {
                        Image(systemName: "camera")
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCaptureFlow) {
                ArtworkCaptureFlow()
            }
        }
    }
}

struct StudioWorkshopView: View {
    var body: some View {
        NavigationView {
            Text("Studio Workshop")
                .navigationTitle("Studio Workshop")
        }
    }
}

struct ProfileView: View {
    @StateObject private var artworkManager = ArtworkManager.shared
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(action: {
                        artworkManager.resetAllData()
                    }) {
                        HStack {
                            Text("Reset All Data")
                                .foregroundColor(.red)
                            Spacer()
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                } header: {
                    Text("Data Management")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            GalleriesView()
                .tabItem {
                    Image(systemName: "photo.stack")
                    Text("Galleries")
                }
            
            StudioWorkshopView()
                .tabItem {
                    Image(systemName: "paintbrush")
                    Text("Studio")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
