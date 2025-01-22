//
//  ChampionView.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct ChampionView: View {
    var body: some View {
        VStack {
            List(champions) { champion in ChampionRow(champion: champion)}
        }
    }
}

#Preview {
    ChampionView()
}
