//
//  PlayerIcon.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct PlayerIcon: View {
    var player: Player

    var body: some View {
        player.headshot
            .resizable()
            .frame(width: 53, height: 38)
            .clipShape(Circle())
            .background(
                Circle().fill(.white)
            )
            .overlay {
                Circle().stroke(Color(red: 0.36, green: 0.17, blue: 0.51), lineWidth: 2)
            }
            .shadow(radius: 4)
    }
}

#Preview {
    PlayerIcon(player: players[0])
    PlayerIcon(player: players[1])
    PlayerIcon(player: players[2])
}
