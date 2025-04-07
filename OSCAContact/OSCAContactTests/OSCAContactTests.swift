#if canImport(XCTest) && canImport(OSCATestCaseExtension)
import XCTest
import Combine
import OSCANetworkService
import OSCATestCaseExtension
@testable import OSCAContact

final class OSCAContactTests: XCTestCase {
  static let moduleVersion = "1.0.3"
  
  private var cancellables        : Set<AnyCancellable>!
  private var contactFormContact  : OSCAContactFormContact?
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    self.cancellables = []
  }// end override func setupWithError
  
  func testModuleInit() throws -> Void {
    // init module
    let module = try makeDevModule()
    XCTAssertNotNil(module)
    XCTAssertEqual(module.bundlePrefix, "de.osca.contact")
    XCTAssertEqual(module.version, OSCAContactTests.moduleVersion)
    // init bundle
    let bundle = OSCAContact.bundle
    XCTAssertNotNil(bundle)
    XCTAssertNotNil(self.devPlistDict)
    XCTAssertNotNil(self.productionPlistDict)
  }// end func testModuleInit
  
  func testDownloadContactFormContact() throws -> Void {
    var contactFormContacts: [OSCAContactFormContact] = []
    var error: Error?
    
    let expectation = self.expectation(description: "GetContactFormContacts")
    let module = try makeDevModule()
    module.getContactFormContacts(limit: 1)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(encounteredError):
          error = encounteredError
          expectation.fulfill()
        }// end switch completion
      } receiveValue: { result in
        switch result {
        case let .success(objects):
          contactFormContacts = objects
        case let .failure(encounteredError):
          error = encounteredError
        }// end switch result
      }// end sink
      .store(in: &self.cancellables)
    waitForExpectations(timeout: 10)
    
    XCTAssertNil(error)
    XCTAssertTrue(contactFormContacts.count == 1)
  }// end func testDownloadContactFormContact
  
  func testDownloadPrivacyText() throws -> Void {
    var contactParseConfig: OSCAContactParseConfig?
    var error: Error?
    
    let expectation = self.expectation(description: "GetPrivacyText")
    let module = try makeDevModule()
    let publisher: AnyPublisher<OSCAContactParseConfig, Error> = module.getParseConfigParams()
    publisher
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(err):
          error = err
          expectation.fulfill()
        }
      } receiveValue: { config in
        contactParseConfig = config
      }
      .store(in: &self.cancellables)
    waitForExpectations(timeout: 10)
    XCTAssertNil(error)
    XCTAssertNotNil(contactParseConfig)
    XCTAssertNotNil(contactParseConfig?.privacyText)
  }// end testDownloadPrivacyText
  
  func testFetchContactFormContacts() throws -> Void {
    var contactFormContacts: [OSCAContactFormContact] = []
    var error: Error?
    
    let expectation = self.expectation(description: "test fetching contact form contacts from network")
    let networkService = try makeDevModuleDependencies().networkService
    let classRequest = try makeDevContactFromContactRequest()
    let publisher = networkService.fetch(classRequest)
    publisher
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(networkError):
          error = networkError
          expectation.fulfill()
        }
      } receiveValue: { response in
        contactFormContacts = response
      }
      .store(in: &self.cancellables)
    //waitForExpectations(timeout: 10)
    wait(for: [expectation], timeout: 10)
    XCTAssertNil(error)
    XCTAssertFalse(contactFormContacts.isEmpty)
    guard let contactFormContact = contactFormContacts.first(where: { $0.email == "stephan.breidenbach@solingen.de" }) else {
      XCTFail("No contact with stephan.breidenbach@solingen.de found!")
      return
    }// end guard
    XCTAssertNotNil(contactFormContact.objectId)
    self.contactFormContact = contactFormContact
  }// end func testFetchContactFormContacts
  
  func testSendContactFormData() throws -> Void {
    var response: ParseUploadResponse?
    var error: Error?
    let expectation = self.expectation(description: "test send contact form data to network")
    
    try testFetchContactFormContacts()
    guard let contactFormContact = self.contactFormContact,
          let contactId = contactFormContact.objectId else {XCTFail("No valid contact form contact found!"); return}
    
    let contactFormData = OSCAContactFormData(
      name         : "Stephan Breidenbach",
      address      : nil,
      postalCode   : nil,
      city         : nil,
      phone        : nil,
      email        : "stephan.breidenbach@solingen.de",
      message      : "This is a test contact processed by automatic JUnit testing!",
      contactId    : contactId)
    
    let module = try makeDevModule()
    
    module
      .send(contactFormData: contactFormData)
      .sink { completion in
        switch completion {
        case .finished:
          expectation.fulfill()
        case let .failure(err):
          error = err
          expectation.fulfill()
        }
      } receiveValue: { result in
        switch result {
        case let .success(object):
          response = object
        case let .failure(encounteredError):
          error = encounteredError
        }// end switch result
      }
      .store(in: &self.cancellables)
    //waitForExpectations(timeout: 10)
    wait(for: [expectation], timeout: 10)
    XCTAssertNil(error)
    XCTAssertNotNil(response)
  }// end testSendContactFormData
}// end final class OSCAContactTests

// MARK: - factory methods
extension OSCAContactTests {
  public func makeDevModuleDependencies() throws -> OSCAContactDependencies {
    let networkService = try makeDevNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.contact")
    let deeplinkScheme = try makeDevDeeplinkScheme()
    let dependencies = OSCAContactDependencies(
      networkService: networkService,
      userDefaults: userDefaults,
      deeplinkScheme: deeplinkScheme)
    return dependencies
  }// end public func makeDevModuleDependencies
  
  public func makeDevContactFromContactRequest() throws -> OSCAClassRequestResource<OSCAContactFormContact> {
    let networkService = try makeDevNetworkService()
    let config = networkService.config
    let resource = OSCAClassRequestResource<OSCAContactFormContact>.contactFormContact(baseURL: config.baseURL,
                                                               headers: config.headers)
    return resource
  }// end func makeDevContactFromContactRequest
  
  public func makeDevModule() throws -> OSCAContact {
    let devDependencies = try makeDevModuleDependencies()
    // initialize module
    let module = OSCAContact.create(with: devDependencies)
    return module
  }// end public func makeDevModule
  
  public func makeProductionModuleDependencies() throws -> OSCAContactDependencies {
    let networkService = try makeProductionNetworkService()
    let userDefaults   = try makeUserDefaults(domainString: "de.osca.contact")
    let deeplinkScheme = try makeProductionDeeplinkScheme()
    let dependencies = OSCAContactDependencies(
      networkService: networkService,
      userDefaults: userDefaults,
      deeplinkScheme: deeplinkScheme)
    return dependencies
  }// end public func makeProductionModuleDependencies
  
  public func makeProductionModule() throws -> OSCAContact {
    let productionDependencies = try makeProductionModuleDependencies()
    // initialize module
    let module = OSCAContact.create(with: productionDependencies)
    return module
  }// end public func makeProductionModule
}// end extension final class OSCAContactTests
#endif
