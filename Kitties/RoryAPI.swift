//
//  RoryAPI.swift
//  Kitties
//
//  Created by Marcel Mrówka on 12/10/2026.
//

import Foundation
internal import System

class RoryAPI {
    static func getJSON() async throws -> RoryJSON {
        
        let APIUrl = "https://rory.cat/purr"
        
        guard let ActualUrl = URL(string: APIUrl) else { throw Backend.NewAPIError.somethingWentWrong }
        
        let (data, response) = try await URLSession.shared.data(from: ActualUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Backend.NewAPIError.Htmlisnt200
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RoryJSON.self, from: data)
        } catch {
            throw Backend.NewAPIError.cantPharse
        }
    }
    
    static func getURL(catID: Int) async throws -> RoryURL {
        
        let APIUrl = "https://rory.cat/purr/" + String(catID)
        
        guard let ActualUrl = URL(string: APIUrl) else { throw Backend.NewAPIError.somethingWentWrong }
        
        let (data, response) = try await URLSession.shared.data(from: ActualUrl)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw Backend.NewAPIError.Htmlisnt200
        }
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RoryURL.self, from: data)
        } catch {
            throw Backend.NewAPIError.cantPharse
        }
    }
    
    struct RoryJSON: Codable {
        let id: Int
    }
    
    struct RoryURL: Codable {
        let url: String
    }
}
