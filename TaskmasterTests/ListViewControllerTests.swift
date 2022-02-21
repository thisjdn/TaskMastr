//
//  ListViewControllerTests.swift
//  TaskmastrTests
//
//  Created by Jaden Hong on 2022-02-20.
//

import XCTest
@testable import Taskmastr

class ListViewControllerTests: XCTestCase {
    var sut : ListViewController!
    
    override func setUp() {
        super.setUp()
        sut = ListViewController()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSave_CRUD() {
        XCTAssertNoThrow(sut.save(), "testSave failed. Error Thrown.")
    }
    
    func testDel_CRUD() {
        XCTAssertNotNil(sut.del(_:))
    }

}
