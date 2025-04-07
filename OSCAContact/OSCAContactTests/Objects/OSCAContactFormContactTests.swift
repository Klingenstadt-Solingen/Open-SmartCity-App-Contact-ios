//
//  OSCAContactFormContactTests.swift
//  OSCAContactTests
//
//  Created by Stephan Breidenbach on 20.01.23.
//

#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import Foundation
import OSCAEssentials
import OSCANetworkService
@testable import OSCAContact
import XCTest
import OSCATestCaseExtension

/// ```console
/// curl -X GET \
///  -H "X-Parse-Application-Id: APPLICATION_ID" \
///  -H "X-Parse-Client-Key: API_CLIENT_KEY" \
///  https://parse-dev.solingen.de/classes/ContactFormContact \
///  | python3 -m json.tool
///  | pygmentize -g
///  ```
class OSCAContactFormContactTests: OSCAParseClassObjectTestSuite<OSCAContactFormContact> {
  override open func makeSpecificObject() -> OSCAContactFormContact? {
    nil
  }// end override open func makeSpecificObject
  
  override func setUpWithError() throws -> Void {
    try super.setUpWithError()
  }// end override func setupWithError
  
  override func tearDownWithError() throws -> Void {
    try super.tearDownWithError()
  }// end override func tearDownWithError
  
  /// Is there a file with the `JSON` scheme example data available?
  /// The file name has to match with the test class name: `OSCAContactFormContactTests.json`
  override func testJSONDataAvailable() throws -> Void {
    try super.testJSONDataAvailable()
  }// end override func testJSONDataAvailable
#if DEBUG
  /// Is it possible to deserialize `JSON` scheme example data to an array  `OSCAContactFormContact` 's?
  override func testDecodingJSONData() throws -> Void {
    try super.testDecodingJSONData()
  }// end override func testDecodingJSONData
#endif
  /// is it possible to fetch up to 1000 `OSCAContactFormContact` objects in an array from network?
  override func testFetchAllParseObjects() throws -> Void {
    try super.testFetchAllParseObjects()
  }// end override func test testFetchAllParseObjects
  
  override func testFetchParseObjectSchema() throws -> Void {
    try super.testFetchParseObjectSchema()
  }// end override func test testFetchParseObjectSchema
}// end class OSCAContactFormContactTests
#endif
