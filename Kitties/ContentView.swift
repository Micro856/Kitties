//
//  ContentView.swift
//  Kitties
//
//  Created by Marcel Mrówka on 24/07/2026.
//

import SwiftUI
import AppKit
internal import System
import Foundation

struct ContentView: View {
    
    @State private var imageurl = Backend.currentURL(url: "https://example.org")
    @State private var isShowingDetails = false
    @State private var isShowingCatID = false
    @State private var catID = 0
    @State private var dieIcon = "die.face." + String(Int.random(in: 1..<6)) + ".fill"
    
    enum Cat: String, CaseIterable, Identifiable {
        case gary, garfield, goober, gully, rory
        var id: Self { self }
    }
    
    @State private var selectedCat: Cat = .gary
    
    @State private var backend = Backend()
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageurl.url)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack {
                Button("Show image details", systemImage: "info.circle") {
                            self.isShowingDetails = true
                        }
                .help("Show image details")
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                        .popover(isPresented: $isShowingDetails) {
                            Grid {
                                GridRow {
                                    Text("Image URL")
                                    Link(imageurl.url,
                                          destination: URL(string: imageurl.url)!)
                                }
                                if selectedCat == .rory {
                                        Divider()
                                        GridRow {
                                        Text("Licence")
                                        Link("CC BY 4.0",
                                              destination: URL(string: "https://rory.cat/license")!)
                                    }
                                }
                            }
                            .padding()
                        }
                Spacer()
                Button("Randomize", systemImage: dieIcon, action: {
                    Task {
                        dieIcon = "die.face." + String(Int.random(in: 1..<6)) + ".fill"
                        catID = await backend.refreshID(selectedCat: selectedCat).number
                        print(catID)
                        imageurl = await backend.refreshURL(selectedCat: selectedCat, catID: catID)
                        print(imageurl.url)
                    }
                })
                .help("Randomize")
                .labelStyle(.iconOnly)
                .buttonStyle(.borderedProminent)
                Button("Download image", systemImage: "arrow.down.circle", action: {
                    print("meow")
                })
                .help("Download image")
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                Spacer()
                Button("Show picture selector", systemImage: "pawprint.fill") {
                            self.isShowingCatID = true
                        }
                .help("Show picture selector")
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                        .popover(isPresented: $isShowingCatID) {
                            Form {
                                    Picker("Cat", selection: $selectedCat) {
                                        Label("Gary", systemImage: "cat.fill").tag(Cat.gary)
                                        Label("Garfield", systemImage: "cat.fill").tag(Cat.garfield)
                                        Label("Goober", systemImage: "cat.fill").tag(Cat.goober)
                                        Label("Gully", systemImage: "cat.fill").tag(Cat.gully)
                                        Label("Rory", systemImage: "cat.fill").tag(Cat.rory)
                                    }
                                    .onChange(of: selectedCat) {
                                        Task {
                                            dieIcon = "die.face." + String(Int.random(in: 1..<6)) + ".fill"
                                            catID = await backend.refreshID(selectedCat: selectedCat).number
                                            print(catID)
                                            imageurl = await backend.refreshURL(selectedCat: selectedCat, catID: catID)
                                            print(imageurl.url)
                                            
                                        }
                                    }
                                    TextField("Picture no.", value: $catID, format: .number)
                                    .onSubmit {
                                        Task {
                                            imageurl = await backend.refreshURL(selectedCat: selectedCat, catID: catID)
                                            print(imageurl.url)
                                        }
                                    }
                                }
                                .padding()
                            }
            }
        }
        .padding()
        .task {
            catID = await backend.refreshID(selectedCat: selectedCat).number
            print(catID)
            imageurl = await backend.refreshURL(selectedCat: selectedCat, catID: catID)
            print(imageurl.url)
        }
    }
}


#Preview {
    ContentView()
}
