//
//  CatFact.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import Foundation

struct CatFact: Decodable {
    let data: [String]
}

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}
