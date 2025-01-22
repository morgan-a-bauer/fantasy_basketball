//
//  LandmarkList.swift
//  Landmarks
//
//  Created by Morgan Bauer on 1/21/25.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        List(landmarks) { landmark in
            LandmarkRow(landmark: landmark)
        }
    }
}

#Preview {
    LandmarkList()
}
