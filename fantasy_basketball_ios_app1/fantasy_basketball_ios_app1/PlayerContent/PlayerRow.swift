//
//  PlayerRow.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct PlayerRow: View {
    var player: Player
    var body: some View {
        HStack {
            PlayerIcon(player: player)
            
            Spacer()
            
            VStack(alignment: .trailing){
                Text(player.id)
                    .font(.title)
                Text(player.avg_fan_pts)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    PlayerRow(player: players[0])
}
