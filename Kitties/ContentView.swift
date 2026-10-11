//
//  ContentView.swift
//  Kitties
//
//  Created by Marcel on 24/07/2026.
//

import SwiftUI
internal import System

struct ContentView: View {
    
    @State private var imageurl: imageJSON?
    
    enum Cat: String, CaseIterable, Identifiable {
        case gary, goober
        var id: Self { self }
    }
    
    @State private var selectedCat: Cat = .gary
    
    var body: some View {
        VStack {
            VStack {
                Picker("", selection: $selectedCat) {
                    Text("Gary").tag(Cat.gary)
                    Text("Goober").tag(Cat.goober)
                }
                .pickerStyle(.segmented)
            }
            AsyncImage(url: URL(string: imageurl?.url ?? "https://example.org")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Button("Randomize", systemImage: "die.face.3.fill", action: {
                Task {await refresh()}
            })
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .task {
            await refresh()
        }
    }
    
    func refresh() async {
        do {
            if selectedCat == .gary {
                imageurl = try await getJSON(meow: "gary")
            } else if selectedCat == .goober {
                imageurl = try await getJSON(meow: "goober")
            }
        } catch APIError.somethingWentWrong{
            print("something went wrong with getting data")
        } catch APIError.Htmlisnt200{
            print("HTML response isnt 200")
        } catch APIError.cantPharse {
            print("Cant pharse JSON")
        } catch {
            print("No idea what went wrong")
        }
    }
    
    func getJSON(meow: String) async throws -> imageJSON {
        
        let APIUrl = "https://api.garythe.cat/" + meow
        
        guard let ActualUrl = URL(string: APIUrl) else { throw APIError.somethingWentWrong }
        
        let (data, response) = try await URLSession.shared.data(from: ActualUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw APIError.Htmlisnt200
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(imageJSON.self, from: data)
        } catch {
            throw APIError.cantPharse
        }
    }
}

#Preview {
    ContentView()
}

struct imageJSON: Codable {
    let url: String
    let number: Int
}

enum APIError: Error {
    case somethingWentWrong
    case Htmlisnt200
    case cantPharse
}
