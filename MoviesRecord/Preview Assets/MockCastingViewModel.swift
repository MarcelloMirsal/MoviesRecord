//
//  MockCastingViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 08/05/2022.
//

import Foundation

final class MockCastingViewModel: CastingViewModel {
    override var movieCasts: [MovieCast] {
        return [
            .init(id: 222121, originalName: "Ben Schwartz", profilePath: "/5vV52TSEIhe4ZZLWwv3i7nfv8we.jpg", character: "Sonic the Hedgehog (voice)"),
            .init(id: 17605, originalName: "Idris Elba", profilePath: "/be1bVF7qGX91a6c5WeRPs5pKXln.jpg", character: "Knuckles the Echidna (voice)"),
            .init(id: 1212864, originalName: "Colleen O'Shaughnessey", profilePath: "/y3Kl5tCX1XD6uyL9wefTRbEXTwj.jpg", character: "Miles 'Tails' Prower (voice)"),
            .init(id: 206, originalName: "Jim Carrey", profilePath: "/u0AqTz6Y7GHPCHINS01P7gPvDSb.jpg", character: "Dr. Ivo Robotnik"),
        ].shuffled()
    }
}
