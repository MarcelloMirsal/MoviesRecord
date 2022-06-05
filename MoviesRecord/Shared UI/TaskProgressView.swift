//
//  TaskProgressView.swift
//  EarthBlue
//
//  Created by Marcello Mirsal on 28/12/2021.
//

import SwiftUI

struct TaskProgressView: View {
    var body: some View {
        ProgressView()
            .tint(.primary)
            .padding(18)
            .background(Material.ultraThinMaterial)
            .cornerRadius(8)
    }
}


struct TaskProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TaskProgressView()
    }
}
