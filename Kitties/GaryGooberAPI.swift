//
//  GaryGooberAPI.swift
//  Kitties
//
//  Created by Marcel Mrówka on 12/10/2026.
//

import SwiftUI
internal import System

class GaryGooberAPI {
    static func getJSON(meow: String) async throws -> GaryGooberJSON {
        
        let APIUrl = "https://api.garythe.cat/" + meow
        
        guard let ActualUrl = URL(string: APIUrl) else { throw Backend.NewAPIError.somethingWentWrong }
        
        let (data, response) = try await URLSession.shared.data(from: ActualUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Backend.NewAPIError.Htmlisnt200
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(GaryGooberJSON.self, from: data)
        } catch {
            throw Backend.NewAPIError.cantPharse
        }
    }
    
    static func getURL(meow: String, catID: Int) -> GaryGooberURL {
        
        let catUrl = "https://cdn.garythe.cat/" + meow + "/" + meow + String(catID) + ".jpg"
        return GaryGooberURL(url: catUrl)
    }
    
    struct GaryGooberJSON: Codable {
        let number: Int
    }
    
    struct GaryGooberURL: Codable {
        let url: String
    }
}
