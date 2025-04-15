//
//  CatInteractor.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import Foundation
import Combine

protocol CatInteractorProtocol {
    func fetchAFact() -> AnyPublisher<CatFact, Error>
    func fetchImage() -> AnyPublisher<[CatImage], Error>
}



class CatInteractor: CatInteractorProtocol {
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchAFact() -> AnyPublisher<CatFact, any Error> {
        struct GetFactRequest: APIRequest {
            typealias Response = CatFact
            var url: String {"https://meowfacts.herokuapp.com/"}
            var method: String { "GET" }
            var headers: [String: String]? { nil }
            var queryItems: [URLQueryItem]? { nil }
            var body: Data? { nil }
        }
        let request = GetFactRequest()
        return networkService.request(request)
    }
    
    func fetchImage() -> AnyPublisher<[CatImage], any Error> {
        struct GetImageRequest: APIRequest {
            typealias Response = [CatImage]
            var url: String {"https://api.thecatapi.com/v1/images/search"}
            var method: String { "GET" }
            var headers: [String: String]? { nil }
            var queryItems: [URLQueryItem]? { [URLQueryItem(name: "mime_types", value: "png"), URLQueryItem(name: "size", value: "small")] }
            var body: Data? { nil }
        }
        let request = GetImageRequest()
        return networkService.request(request)
    }
}
