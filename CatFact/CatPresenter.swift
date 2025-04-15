//
//  CatPresenter.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 14/04/25.
//

import Foundation
import Combine

protocol CatPresenterProtocol {
    var fact: CatFact { get }
    var errorMessage: String? { get }
    func refresh()
}


class CatPresenter : ObservableObject, CatPresenterProtocol {
    @Published private(set) var caturl = ""
    @Published private(set) var fact: CatFact = .init(data: [])
    @Published private(set) var errorMessage: String?
    @Published var showingAlert = false
    private var cancellables = Set<AnyCancellable>()
    var interactor: CatInteractorProtocol
    init(interactor: CatInteractorProtocol) {
            self.interactor = interactor
        }
    
    func refresh() {
        getFact()
        getCatImage()
    }
    
    private func getFact() {
        interactor.fetchAFact().sink { [weak self] completion in
                switch completion {
                    case .finished:
                        print("success - fact fetched")
                    case .failure(let error):
                        self?.showingAlert = true
                        self?.errorMessage = error.localizedDescription
                }
            } receiveValue: {[weak self]  value in
                
                self?.fact = value
            }
            .store(in: &cancellables)
    }
    private func getCatImage() {
        interactor.fetchImage()
            .sink { [weak self] completion in
                switch completion {
                    case .finished:
                        print("success - cought the cat")
                    case .failure(let error):
                        self?.showingAlert = true
                        self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] images in
                print("Cats - ", images)
                self?.caturl = images.first?.url ?? ""
            }
            .store(in: &cancellables)
    }
}
