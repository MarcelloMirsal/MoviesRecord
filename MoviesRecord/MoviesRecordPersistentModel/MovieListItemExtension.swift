//
//  MovieListItem+CoreDataClass.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 05/06/2022.
//
//

import Foundation
import CoreData

extension MovieListItem {
    var movieTitle: String {
        return title ?? ""
    }

    var formattedStringDate: String {
        guard let date = date else {return ""}
        return DateFormatter.stringDate(fromSharedFormattedDate: date)
    }
}
