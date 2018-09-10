//
//  RecentSearchStoreTests.swift
//  GiphyExampleTests
//
//  Created by Paola Mata on 9/8/18.
//  Copyright © 2018 Paola Mata. All rights reserved.
//

import XCTest
@testable import GiphyExample

class RecentSearchStoreTests: XCTestCase {
    var sut: RecentSearchStoreMock?
    
    override func setUp() {
        super.setUp()

        sut = RecentSearchStoreMock.sharedMock
    }
    
    func testSaveAndGetTerm() {
        sut?.saveSearchTerm("test")
        
        let expectation = self.expectation(description: "save")
        sut?.getSearchTerms(completion: { terms in
            
            expectation.fulfill()
            
            XCTAssertTrue(terms.contains("test"))
            XCTAssertFalse(terms.contains("fake"))
        })
        
        waitForExpectations(timeout: 15, handler: nil)
    }
}

class RecentSearchStoreMock: RecentSearchTermsStore {
    static let sharedMock = RecentSearchStoreMock()
        
    override var fileURL: URL {
        let fileURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        return fileURL.appendingPathComponent("RecentSearchTermsMock.plist")
    }
}
