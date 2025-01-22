//
//  Champion.swift
//  fantasy_basketball_ios_app1
//
//  Created by Morgan Bauer on 1/21/25.
//

import Foundation
import SwiftUI

struct Champion: Hashable, Codable, Identifiable {
    var id: String
    var year: String
    var record: String
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
