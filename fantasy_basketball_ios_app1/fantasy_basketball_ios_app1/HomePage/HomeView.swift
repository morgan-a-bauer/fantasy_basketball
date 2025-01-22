//
//  HomeView.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Top Players")
            // TODO: Make a list of highest performers
            List(players) { player in PlayerRow(player: player)}
        }
    }
}

#Preview {
    HomeView()
}
