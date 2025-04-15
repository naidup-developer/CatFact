//
//  CatFactApp.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import SwiftUI
import SwiftData

@main
struct CatFactApp: App {
    var body: some Scene {
        WindowGroup {
            CatRouter.createView()
        }
    }
}
