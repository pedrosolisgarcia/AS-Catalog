//
//  ValidatorTests.swift
//  CatalogTests
//
//  Created by Pedro Solís García on 22/06/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import XCTest
@testable import Catalog

class ValidatorTests: XCTestCase {
  
  override func setUpWithError() throws {
      // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testSingleShortWordNameShouldValidate() throws {
    let clientName = "agnieszka"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertTrue(result)
  }
  
  func testManyWordsNameShouldValidate() throws {
    let clientName = "agnieszka swiatly"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertTrue(result)
  }
  
  func testBlankNameShouldNotValidate() throws {
    let clientName = ""
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertTrue(result)
  }
  
  func testTooLongNameShouldNotValidate() throws {
    let clientName = "agnieszkaagnieszkaagnieszkaagnieszkaagnieszkaagnieszka"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertFalse(result)
  }
  
  func testNameWithSpecialCharactersShouldNotValidate() throws {
    let clientName = "agnieszka!"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPhpInjectionShouldNotValidate() throws {
    let clientName = "<?php echo 'hello world'; ?>"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPolishCharactersShouldValidate() throws {
    let clientName = "łóśżźęąńć"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertTrue(result)
  }
  
  func testNameWithPolishCharactersOnUpperCaseShouldValidate() throws {
    let clientName = "łóśżźęąńć"
    let result = ClientDataValidator.validateClientName(name: clientName.uppercased())
    XCTAssertTrue(result)
  }
  
  func testNameWithNumbersShouldValidate() throws {
    let clientName = "agnieszka2"
    let result = ClientDataValidator.validateClientName(name: clientName)
    XCTAssertTrue(result)
  }
  
  func testWithEmptyFieldShouldNotValidate() throws {
    let field = ""
    let result = ClientDataValidator.validateField(field: field)
    XCTAssertFalse(result)
  }
  
  func testWithFieldShouldValidate() throws {
    let field = "wroclawID"
    let result = ClientDataValidator.validateField(field: field)
    XCTAssertTrue(result)
  }
}
