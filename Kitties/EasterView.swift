//
//  EasterView.swift
//  Kitties
//
//  Created by Marcel Mrówka on 16/10/2026.
//

import SwiftUI
internal import System

struct EasterView: View {
    
    var body: some View {
        HStack {
            Image("Rudi")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
    }
}


#Preview {
    EasterView()
}
