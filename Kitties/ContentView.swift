//
//  ContentView.swift
//  Kitties
//
//  Created by Marcel Mrówka on 24/07/2026.
//

import SwiftUI
internal import System
import Foundation

struct ContentView: View {
    
    @Environment(\.openWindow) var openWindow
    
    @State private var imageurl = Backend.currentURL(url: "https://example.org")
    @State private var isShowingDetails = false
    @State private var isShowingCatID = false
    @State private var catID = 0
    @State private var dieIcon = "die.face.1.fill"
    
    @State private var EasterCounter = 0
    
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
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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
                        await catRandomizeButton()
                    }
                })
                .help("Show a random image of the selected cat")
                //.labelStyle(.iconOnly)
                .buttonStyle(.borderedProminent)
                //Button("Download image", systemImage: "arrow.down.circle", action: {
                //
                //})
                //.help("Download image")
                //.labelStyle(.iconOnly)
                //.buttonStyle(.bordered)
                Spacer()
                Button("Show picture selector", systemImage: "pawprint.fill") {
                    EasterCounter += 1
                    if EasterCounter >= 6 {
                        EasterCounter = 0
                        openWindow(id: "easter-egg")
                    } else {
                        self.isShowingCatID = true
                        
                    }
                            
                }
                .help("Show picture selector")
                .labelStyle(.iconOnly)
                .buttonStyle(.bordered)
                        .popover(isPresented: $isShowingCatID) {
                            Form {
                                    Picker("Cat", selection: $selectedCat) {
                                        Label {
                                            Text("Garfield")
                                        } icon: {
                                            Image("garfieldFace")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .tag(Cat.garfield)
                                        Label {
                                            Text("Gary")
                                        } icon: {
                                            Image("garyFace")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .tag(Cat.gary)
                                        Label {
                                            Text("Goober")
                                        } icon: {
                                            Image("gooberFace")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .tag(Cat.goober)
                                        Label {
                                            Text("Gully")
                                        } icon: {
                                            Image("gullyFace")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .tag(Cat.gully)
                                        Label {
                                            Text("Rory")
                                        } icon: {
                                            Image("roryFace")
                                                .resizable()
                                                .frame(width: 16, height: 16)
                                        }
                                        .tag(Cat.rory)
                                    }
                                    .onChange(of: selectedCat) {
                                        Task {
                                            EasterCounter = 0
                                            await catRandomizeID()
                                            await catLoadUrl()
                                            
                                        }
                                    }
                                    TextField("Picture no.", value: $catID, format: .number)
                                    .onSubmit {
                                        Task {
                                            EasterCounter = 0
                                            await catLoadUrl()
                                        }
                                    }
                                }
                                .padding()
                            }
            }
        }
        .padding()
        .task {
            await catRandomizeButton()
        }
    }
    
    func catRandomizeButton() async {
        dieIcon = "die.face." + String(Int.random(in: 1..<6)) + ".fill"
        await catRandomizeID()
        await catLoadUrl()
    }
    
    func catRandomizeID() async {
        catID = await backend.refreshID(selectedCat: selectedCat).number
        print(catID)
    }
    
    func catLoadUrl() async {
        imageurl = await backend.refreshURL(selectedCat: selectedCat, catID: catID)
        print(imageurl.url)
    }
}


#Preview {
    ContentView()
}
