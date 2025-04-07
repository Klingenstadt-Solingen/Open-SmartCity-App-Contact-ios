//
//  OSCAContact.swift
//  OSCAContact
//
//  Created by Stephan Breidenbach on 24.01.22.
//  Reviewed by Stephan Breidenbach on 21.06.22
//
import Combine
import Foundation
import OSCAEssentials
import OSCANetworkService

public struct OSCAContactDependencies {
  let networkService: OSCANetworkService
  let userDefaults: UserDefaults
  let analyticsModule: OSCAAnalyticsModule?
  let deeplinkScheme: String

  public init(networkService: OSCANetworkService,
              userDefaults: UserDefaults,
              analyticsModule: OSCAAnalyticsModule? = nil,
              deeplinkScheme: String) {
    self.networkService = networkService
    self.userDefaults = userDefaults
    self.analyticsModule = analyticsModule
    self.deeplinkScheme = deeplinkScheme
  } // end public init
} // end public struct OSCAContactDependencies

/// Contact module
public struct OSCAContact: OSCAModule {
  /// module DI container
  var moduleDIContainer: OSCAContactDIContainer!

  let transformError: (OSCANetworkError) -> OSCAContactError = { networkError in
    switch networkError {
    case OSCANetworkError.invalidResponse:
      return OSCAContactError.networkInvalidResponse
    case OSCANetworkError.invalidRequest:
      return OSCAContactError.networkInvalidRequest
    case let OSCANetworkError.dataLoadingError(statusCode: code, data: data):
      return OSCAContactError.networkDataLoading(statusCode: code, data: data)
    case let OSCANetworkError.jsonDecodingError(error: error):
      return OSCAContactError.networkJSONDecoding(error: error)
    case OSCANetworkError.isInternetConnectionError:
      return OSCAContactError.networkIsInternetConnectionFailure
    } // end switch case
  } // end let transformOSCANetworkErrorToOSCAContactError closure

  /// version of the module
  public var version: String = "1.0.3"
  /// bundle prefix of the module
  public var bundlePrefix: String = "de.osca.contact"

  /// module `Bundle`
  ///
  /// **available after module initialization only!!!**
  ///
  public internal(set) static var bundle: Bundle!

  public private(set) var userDefaults: UserDefaults!

  ///
  private var networkService: OSCANetworkService

  ///
  private(set) var deeplinkScheme: String

  /**
   create module and inject module dependencies

   ** This is the only way to initialize the module!!! **
   - Parameter moduleDependencies: module dependencies
   ```
   call: OSCAContact.create(with moduleDependencies)
   ```
   */
  public static func create(with moduleDependencies: OSCAContactDependencies) -> OSCAContact {
    var module: Self = Self(networkService: moduleDependencies.networkService,
                            userDefaults: moduleDependencies.userDefaults,
                            deeplinkScheme: moduleDependencies.deeplinkScheme
    )
    module.moduleDIContainer = OSCAContactDIContainer(dependencies: moduleDependencies)

    return module
  } // end public static func create

  /// initializes the contact module
  ///  - Parameter networkService: Your configured network service
  private init(networkService: OSCANetworkService,
               userDefaults: UserDefaults,
               deeplinkScheme: String
  ) {
    self.networkService = networkService
    self.userDefaults = userDefaults
    self.deeplinkScheme = deeplinkScheme
    var bundle: Bundle?
    #if SWIFT_PACKAGE
      bundle = Bundle.module
    #else
      bundle = Bundle(identifier: bundlePrefix)
    #endif
    guard let bundle: Bundle = bundle else {
#warning("TODO: fatalError")
      fatalError("Module bundle not initialized!")
    }
    Self.bundle = bundle
  } // end public init with network service
} // end public struct OSCAContact

extension OSCAContact {
  /// Downloads contact-form's contact data from parse server
  /// - Parameter limit: Limits the amount of contact-form's contacts that gets downloaded from the server
  /// - Parameter query: HTTP query parameter
  /// - Returns: An array of contact-form's contacts for the contact picker
  public func getContactFormContacts(limit: Int = 1000, query: [String: String] = [:]) -> AnyPublisher<Result<[OSCAContactFormContact], Error>, Never> {
    var parameters = query
    parameters["limit"] = "\(limit)"

    var headers = networkService.config.headers
    if let sessionToken = userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }// end if

    return networkService
      .download(OSCAClassRequestResource
        .contactFormContact(baseURL: networkService.config.baseURL,
                            headers: headers,
                            query: parameters))
      .map { .success($0) }
      .catch { error -> AnyPublisher<Result<[OSCAContactFormContact], Error>, Never> in .just(.failure(error)) }
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .receive(on: OSCAScheduler.mainScheduler)
      .eraseToAnyPublisher()
  } // end public func getContactFormContacts

  /// Downloads all config parameters declared in `OSCAContactParseConfigParams` from parse-server
  public func getParseConfigParams() -> AnyPublisher<OSCAContactParseConfig, Error> {
    return networkService
      .download(OSCAConfigRequestResource
        .contactParseConfig(baseURL: networkService.config.baseURL,
                            headers: networkService.config.headers))
      .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
      .receive(on: OSCAScheduler.mainScheduler)
      .eraseToAnyPublisher()
  }// end public func getParseConfigParams

  /// Uploads contact-form's data object to parse server
  /// - Parameter contactFormData: contact-form's data object
  /// - Returns: `ParseUploadResponse`
  public func send(contactFormData: OSCAContactFormData) -> AnyPublisher<Result<ParseUploadResponse, Error>, Never> {
    var headers = networkService.config.headers
    if let sessionToken = userDefaults.string(forKey: "SessionToken") {
      headers["X-Parse-Session-Token"] = sessionToken
    }// end if

    let anyPublisher: AnyPublisher<Result<ParseUploadResponse, Error>, Never> =
      networkService
        .upload(OSCAUploadClassRequestResource<OSCAContactFormData>
          .contactFormData(baseURL: networkService.config.baseURL,
                           headers: headers,
                           uploadParseClassObject: contactFormData))
        .map { .success($0) }
        .catch { error -> AnyPublisher<Result<ParseUploadResponse, Error>, Never> in
          .just(.failure(error))
        }
        .subscribe(on: OSCAScheduler.backgroundWorkScheduler)
        .receive(on: OSCAScheduler.mainScheduler)
        .eraseToAnyPublisher()
    return anyPublisher
  } // end public func send contact form data
} // end extension OSCAContact
