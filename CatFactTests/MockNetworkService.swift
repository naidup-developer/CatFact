//
//  MockNetworkService.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 15/04/25.
//


import XCTest
import Combine
@testable import CatFact

class MockNetworkService: NetworkService {
    var factResponse: CatFact?
    var imageResponse: [CatImage]?
    var error: Error?
    
    func request<T>(_ request: T) -> AnyPublisher<T.Response, Error> where T : APIRequest {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        if let fact = factResponse as? T.Response {
            return Just(fact)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        if let image = imageResponse as? T.Response {
            return Just(image)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
    }
}
