//
//  ChampionRow.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct ChampionRow: View {
    var champion: Champion

    var body: some View {

        HStack {

            champion.image
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 7)

            Spacer()
            
            VStack(alignment: .trailing) {
                Text(champion.id)
                    .font(.title)
                Text(champion.year + " | " + champion.record)
            }
            .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ChampionRow(champion: champions[0])
}
