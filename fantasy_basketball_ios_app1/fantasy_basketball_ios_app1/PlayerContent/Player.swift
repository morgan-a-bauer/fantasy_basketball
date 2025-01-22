//
//  Player.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import Foundation
import SwiftUI

struct Player: Hashable, Codable, Identifiable {
    var id: String
    var avg_fan_pts: String
    
    private var headshotName: String
    var headshot: Image {
        Image(headshotName)
    }
}
