//
//  DeeplinkURLTests.swift
//  OSCAContactTests
//
//  Created by Stephan Breidenbach on 12.07.22.
//

import XCTest
import OSCAEssentials
@testable import OSCAContact

class DeeplinkURLTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      try super.setUpWithError()
    }// end override func setUpWithError

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      try super .tearDownWithError()
    }// end override func tearDownWithError

    func testContactFormDeeplink() throws {
      let deeplinkScheme = try makeDevDeeplinkScheme()
      let contactFormURLString = DeeplinkURL.contactForm.rawValue
      let testURLString = "\(deeplinkScheme)://\(contactFormURLString)"
      let devModuleTests = makeOSCAContactTests()
      let devModule = try devModuleTests.makeDevModule()
      let deeplinkURLString: String = devModule.deeplinkURL(with: DeeplinkURL.contactForm)
      XCTAssertEqual(testURLString, deeplinkURLString, "maleformed deeplink URL string")
    }// end func testContactFormDeeplink
}// end class DeeplinkURLTests

extension DeeplinkURLTests {
  public func makeOSCAContactTests() -> OSCAContactTests {
    return OSCAContactTests()
  }// end public func makeOSCAContactTests
}
