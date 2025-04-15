//
//  CatInteractorTests.swift
//  CatFact
//
//  Created by Chanti Palavalasa on 15/04/25.
//
import XCTest
import Combine
@testable import CatFact

// MARK: - Interactor Tests
final class CatInteractorTests: XCTestCase {
    var interactor: CatInteractor!
    var mockService: MockNetworkService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
    }

    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        interactor = CatInteractor(networkService: mockService)
    }

    func testFetchAFactSuccess() throws {
        print(#function, "Test started")
        let expectedFact = CatFact(data: ["Fun cat fact!"])
        mockService.factResponse = expectedFact
        let expectation = self.expectation(description: "Fact fetched")

        interactor.fetchAFact()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { fact in
                XCTAssertEqual(fact.data.first, expectedFact.data.first)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 60.0)
    }

    func testFetchImageSuccess() throws {
        print(#function, "Test started")
        let expectedImage = [CatImage(id: "1", url: "https://cdn2.thecatapi.com/images/MTk0MDk3MA.jpgok", width: 400, height: 400)]
        mockService.imageResponse = expectedImage
        let expectation = self.expectation(description: "Image fetched")

        interactor.fetchImage()
            .sink(receiveCompletion: { _ in },
                  receiveValue: { images in
                XCTAssertEqual(images.first?.url, expectedImage.first?.url)
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 60.0)
    }

    func testFetchFailure() throws {
        mockService.error = URLError(.timedOut)
        let expectation = self.expectation(description: "Error thrown")

        interactor.fetchAFact()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual((error as? URLError)?.code, .timedOut)
                    expectation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }
}
