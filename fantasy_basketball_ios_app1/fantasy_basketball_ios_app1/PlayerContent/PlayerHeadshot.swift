//
//  ExamplePlayerHeadshot.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct PlayerHeadshot: View {
    var player: Player

    var body: some View {
        player.headshot
            .resizable()
            .frame(width: 208, height: 152)
            .clipShape(Circle())
            .background(
                Circle().fill(.white)
            )
            .overlay {
                Circle().stroke(Color(red: 0.36, green: 0.17, blue: 0.51), lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    PlayerHeadshot(player: players[0])
    PlayerHeadshot(player: players[1])
    PlayerHeadshot(player: players[2])
}
