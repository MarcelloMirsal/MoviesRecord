//
//  Extensions.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 20/04/2022.
//

import Foundation


extension DateFormatter {
    static func sharedFormattedDate(stringDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: stringDate) else {return stringDate}
        let posterDateFormatter = DateFormatter()
        posterDateFormatter.dateFormat = "MMM d, yyyy"
        return posterDateFormatter.string(from: date)
    }
}
