//
//  Networking Errors.swift
//  NetworkingServices
//
//  Created by Marcello Mirsal on 20/12/2021.
//

import Alamofire

public enum NetworkError: Error, LocalizedError {
    case noInternetConnection
    case requestTimedOut
    case badResponse
    case unspecified
    init(afError: AFError) {
        self = AFErrorWrapper(afError: afError).mappedError()
    }
    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "The Internet connection appears to be offline."
        case .requestTimedOut:
            return "the request timed out, please try again."
        case .badResponse:
            return "invalid response from server."
        case .unspecified:
            return "Unspecified error occurred."
        }
    }
}

fileprivate struct AFErrorWrapper {
    let afError: AFError
    func mappedError() -> NetworkError {
        switch afError {
        case .responseValidationFailed:
            return .badResponse
        case .sessionTaskFailed(let error):
            guard let urlError = error as? URLError else { return .requestTimedOut }
            switch urlError.code {
            case .notConnectedToInternet, .dataNotAllowed:
                return .noInternetConnection
            case .timedOut:
                return .requestTimedOut
            case .cannotConnectToHost:
                return .requestTimedOut
            default:
                return .badResponse
            }
            
        default:
            return .unspecified
        }
    }
}

//public enum ServiceError: Error, LocalizedError, Equatable {
//    case networkingFailure(NetworkError)
//    case decoding
//    case unspecified
//    public var errorDescription: String? {
//        switch self {
//        case .decoding:
//            return "An error occurred while processing data, please try again."
//        case .networkingFailure(let networkError):
//            return networkError.localizedDescription
//        case .unspecified:
//            return NetworkError.unspecified.errorDescription
//        }
//    }
//}

