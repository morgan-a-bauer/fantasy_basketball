//
//  ExamplePlayerWallpaper.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct ExamplePlayerWallpaper: View {
    var body: some View {
        Image("fox_deaaron_wallpaper")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    ExamplePlayerWallpaper()
}
