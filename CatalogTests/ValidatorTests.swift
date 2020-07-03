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
    let customerName = "agnieszka"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testManyWordsNameShouldValidate() throws {
    let customerName = "agnieszka swiatly"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testBlankNameShouldNotValidate() throws {
    let customerName = ""
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testTooLongNameShouldNotValidate() throws {
    let customerName = "agnieszkaagnieszkaagnieszkaagnieszkaagnieszkaagnieszka"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithSpecialCharactersShouldNotValidate() throws {
    let customerName = "agnieszka!"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPhpInjectionShouldNotValidate() throws {
    let customerName = "<?php echo 'hello world'; ?>"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPolishCharactersShouldValidate() throws {
    let customerName = "łóśżźęąńć"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testNameWithPolishCharactersOnUpperCaseShouldValidate() throws {
    let customerName = "łóśżźęąńć"
    let result = CostumerDataValidator.validateCustomerName(name: customerName.uppercased())
    XCTAssertTrue(result)
  }
  
  func testNameWithNumbersShouldValidate() throws {
    let customerName = "agnieszka2"
    let result = CostumerDataValidator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testWithEmptyFieldShouldNotValidate() throws {
    let field = ""
    let result = CostumerDataValidator.validateField(field: field)
    XCTAssertFalse(result)
  }
  
  func testWithFieldShouldValidate() throws {
    let field = "wroclawID"
    let result = CostumerDataValidator.validateField(field: field)
    XCTAssertTrue(result)
  }
}
