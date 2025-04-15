//
//  CatRouter.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import Foundation
import SwiftUI

protocol CatRouterProtocol {
    associatedtype contentView: View
    static func createView() -> contentView
}


class CatRouter: CatRouterProtocol {
    static func createView() -> some View {
        let networkService = NetworkManager()
        let interator = CatInteractor(networkService: networkService)
        let presenter = CatPresenter(interactor: interator)
        let view = CatFactView(presenter: presenter)
        
        
        return view
    }
    
}
