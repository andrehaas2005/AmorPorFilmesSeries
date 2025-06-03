//
//  AmorPorFilmesSeriesUITests.swift
//  AmorPorFilmesSeriesUITests
//
//  Created by Andre  Haas on 28/05/25.
//

import XCTest

final class AmorPorFilmesSeriesUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
    }
}
