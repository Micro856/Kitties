//
//  Backend.swift
//  Kitties
//
//  Created by Marcel Mrówka on 12/10/2026.
//

internal import System
import SwiftUI

 class Backend {
    
     var garyID: GaryGooberAPI.GaryGooberJSON?
     var roryID: RoryAPI.RoryJSON?
     
     var garyURL: GaryGooberAPI.GaryGooberURL?
     var roryURL: RoryAPI.RoryURL?
    
     func refreshID(selectedCat: ContentView.Cat) async -> currentID {
         do {
             if selectedCat == .gary {
                 garyID = try await GaryGooberAPI.getJSON(meow: "gary")
                 return currentID(number: garyID?.number ?? 0)
             } else if selectedCat == .goober {
                 garyID = try await GaryGooberAPI.getJSON(meow: "goober")
                 return currentID(number: garyID?.number ?? 0)
             } else if selectedCat == .gully {
                 garyID = try await GaryGooberAPI.getJSON(meow: "gully")
                 return currentID(number: garyID?.number ?? 0)
             } else if selectedCat == .garfield {
                 garyID = try await GaryGooberAPI.getJSON(meow: "garfield")
                 return currentID(number: garyID?.number ?? 0)
             } else if selectedCat == .rory {
                 roryID = try await RoryAPI.getJSON()
                 return currentID(number: roryID?.id ?? 0)
             } else {
                 return currentID(number: 0)
             }
         } catch NewAPIError.somethingWentWrong{
             print("something went wrong with getting data")
             return currentID(number: 0)
         } catch NewAPIError.Htmlisnt200{
             print("HTML response isnt 200")
             return currentID(number: 0)
         } catch NewAPIError.cantPharse {
             print("Cant pharse JSON")
             return currentID(number: 0)
         } catch {
             print("No idea what went wrong")
             return currentID(number: 0)
         }
     }
     
     func refreshURL(selectedCat: ContentView.Cat, catID: Int) async -> currentURL {
         do {
             if selectedCat == .gary {
                 garyURL = GaryGooberAPI.getURL(meow: "Gary", catID: catID)
                 return currentURL(url: garyURL?.url ?? "https://example.org")
             } else if selectedCat == .goober {
                 garyURL = GaryGooberAPI.getURL(meow: "Goober", catID: catID)
                 return currentURL(url: garyURL?.url ?? "https://example.org")
             } else if selectedCat == .gully {
                 garyURL = GaryGooberAPI.getURL(meow: "Gully", catID: catID)
                 return currentURL(url: garyURL?.url ?? "https://example.org")
             } else if selectedCat == .garfield {
                 garyURL = GaryGooberAPI.getURL(meow: "Garfield", catID: catID)
                 return currentURL(url: garyURL?.url ?? "https://example.org")
             } else if selectedCat == .rory {
                 roryURL = try await RoryAPI.getURL(catID: catID)
                 return currentURL(url: roryURL?.url ?? "https://example.org")
             } else {
                 return currentURL(url: "https://example.org")
             }
         } catch NewAPIError.somethingWentWrong{
             print("something went wrong with getting data")
             return currentURL(url: "https://example.org")
         } catch NewAPIError.Htmlisnt200{
             print("HTML response isnt 200")
             return currentURL(url: "https://example.org")
         } catch NewAPIError.cantPharse {
             print("Cant pharse JSON")
             return currentURL(url: "https://example.org")
         } catch {
             print("No idea what went wrong")
             return currentURL(url: "https://example.org")
         }
     }

     func Decoding() {

     }

     struct currentID: Codable {
         let number: Int
     }
     
     struct currentURL: Codable {
         let url: String
     }
     
     enum NewAPIError: Error {
         case somethingWentWrong
         case Htmlisnt200
         case cantPharse
     }
 }
