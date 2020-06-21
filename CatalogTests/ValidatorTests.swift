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
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testSingleShortWordNameShouldValidate() {
    let customerName = "agnieszka"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testManyWordsNameShouldValidate() {
    let customerName = "agnieszka swiatly"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testBlankNameShouldNotValidate() {
    let customerName = ""
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testTooLongNameShouldNotValidate() {
    let customerName = "agnieszkaagnieszkaagnieszkaagnieszkaagnieszkaagnieszka"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithSpecialCharactersShouldNotValidate() {
    let customerName = "agnieszka!"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPhpInjectionShouldNotValidate() {
    let customerName = "<?php echo 'hello world'; ?>"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertFalse(result)
  }
  
  func testNameWithPolishCharactersShouldValidate() {
    let customerName = "łóśżźęąńć"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testNameWithPolishCharactersOnUpperCaseShouldValidate() {
    let customerName = "łóśżźęąńć"
    let result = Validator.validateCustomerName(name: customerName.uppercased())
    XCTAssertTrue(result)
  }
  
  func testNameWithNumbersShouldValidate() {
    let customerName = "agnieszka2"
    let result = Validator.validateCustomerName(name: customerName)
    XCTAssertTrue(result)
  }
  
  func testWithEmptyFieldShouldNotValidate() {
    let field = ""
    let result = Validator.validateField(field: field)
    XCTAssertFalse(result)
  }
  
  func testWithFieldShouldValidate() {
    let field = "wroclawID"
    let result = Validator.validateField(field: field)
    XCTAssertTrue(result)
  }
}
