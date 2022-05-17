//
//  MockSearchingViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 11/05/2022.
//

import Foundation


final class MockSearchingViewModel: SearchingViewModel {
    
    override var movies: [Movie] {
        return [.mockedMovie]
    }
}
