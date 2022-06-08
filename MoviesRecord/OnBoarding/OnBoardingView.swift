//
//  OnBoardingView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 06/06/2022.
//

import SwiftUI

struct OnBoardingView: View {
    
    let themeColors = [
        Color(hex: "3a7bd5"),
        Color(hex: "3a6073"),
    ]
    
    @Environment(\.dismiss) var dismiss
    @AppStorage("IsFirstTimeLaunch", store: .standard) var isFirstTimeLaunch: Bool = true
    
    private let onBoardingItems: [OnBoardingItem] = [
        .init(imageName: "chart.bar.xaxis", head: "Discover trending movies", body: "browse all trending movies and its details like casting and images."),
        
            .init(imageName: "list.triangle", head: "Compose movies Lists", body: "create Lists like favorites and watched."),
        
            .init(imageName: "magnifyingglass", head: "Search for movies", body: ""),
        
            .init(imageName: "icloud", head: "Sync Lists with your devices", body: "you can disable sync from Extra."),
    ]
    
    var body: some View {
        VStack {
            Text("Welcome to MoviesRecord")
                .font(.title.bold())
                .foregroundStyle(LinearGradient(colors: themeColors, startPoint: .leading, endPoint: .trailing) )
            List(onBoardingItems, id: \.head) { onboardItem in
                HStack(alignment: .top) {
                    Image(systemName: onboardItem.imageName)
                        .font(.title)
                        .foregroundStyle(LinearGradient(colors: themeColors, startPoint: .leading, endPoint: .trailing) )
                    VStack(alignment: .leading, spacing: 4) {
                        Text(onboardItem.head)
                            .foregroundStyle(LinearGradient(colors: themeColors, startPoint: .leading, endPoint: .trailing) )
                            .font(.title3.bold())
                        Text(onboardItem.body)
                            .foregroundColor(.secondary)
                    }
                }
                .listRowSeparator(.hidden)
                .padding(.vertical, 8)
            }
            .listStyle(.plain)
            .padding(.horizontal)
            Spacer()
            Button {
                isFirstTimeLaunch = false
            } label: {
                Text("Continue")
                    .font(.title2.bold())
                    .padding(.horizontal, 32)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 24)
        .dynamicTypeSize(..<DynamicTypeSize.accessibility3)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        Color.gray
            .sheet(isPresented: .constant(true)) {
                OnBoardingView()
            }
    }
}

private struct OnBoardingItem {
    let imageName: String
    let head: String
    let body: String
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
