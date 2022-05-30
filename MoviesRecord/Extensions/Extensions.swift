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
    
    static func date(fromSharedFormattedStringDate stringDate: String) -> Date {
        let sharedDateFormatter = DateFormatter()
        sharedDateFormatter.dateFormat = "MMM d, yyyy"
        return sharedDateFormatter.date(from: stringDate) ?? .init()
    }
    
    static func stringDate(fromSharedFormattedDate date: Date) -> String {
        let sharedDateFormatter = DateFormatter()
        sharedDateFormatter.dateFormat = "MMM d, yyyy"
        return sharedDateFormatter.string(from: date)
    }
}
