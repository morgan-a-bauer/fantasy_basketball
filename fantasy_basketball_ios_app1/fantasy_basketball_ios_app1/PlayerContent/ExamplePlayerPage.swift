//
//  ExamplePlayerPage.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct ExamplePlayerPage: View {
    var body: some View {
        VStack(alignment: .center) {
            ExamplePlayerWallpaper()
            
            PlayerHeadshot(player: players[0])
                .offset(y: -85)
                .padding(.bottom, -85)
            HStack {
                
                VStack {
                    Text("De'Aaron Fox")
                        .font(.title)
                    Text("PG | Sacramento Kings")
                        .font(.subheadline)
                }
            }
            
            HStack(alignment: .center) {
                VStack(alignment: .center) {
                    Text("3")
                        .font(.title3)
                    Text("Games this week")
                        .font(.caption)
                }
                Spacer()
                
                VStack(alignment: .center) {
                    Text("1635")
                        .font(.title3)
                    Text("Adds")
                        .font(.caption)
                }
                Spacer()
                
                VStack(alignment: .center) {
                    Text("42.75")
                        .font(.title3)
                    Text("Avg. Fan Pts")
                        .font(.caption)
                }
            }
            .padding()
            
        }
        
        Spacer()
    }
}

#Preview {
    ExamplePlayerPage()
}
