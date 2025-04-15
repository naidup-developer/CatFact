//
//  NetworkManager.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import Foundation
import Combine

protocol APIRequest {
    associatedtype Response: Decodable

    var url: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}
extension APIRequest {
    func makeURLRequest() -> URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        return request
    }
}
protocol NetworkService {
    func request<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, Error>
}

class NetworkManager: NetworkService {
    func request<T: APIRequest>(_ request: T) -> AnyPublisher<T.Response, any Error> {
        
        guard let request  = request.makeURLRequest() else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: request)
                .map(\.data)
                .decode(type: T.Response.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
    }
}
