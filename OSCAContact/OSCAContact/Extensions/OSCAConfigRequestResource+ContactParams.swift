//
//  OSCAConfigRequestResource+ContactParams.swift
//  OSCAContact
//
//  Created by Ömer Kurutay on 26.08.22.
//

import OSCANetworkService
import Foundation

extension OSCAConfigRequestResource {
  /// ConfigReqestRessource for defect-form's config params
  /// - Parameters:
  ///   - baseURL: The base url of your parse-server
  ///   - headers: The authentication headers for parse-server
  /// - Returns: A ready to use OSCAConfigRequestResource
  static func contactParseConfig(baseURL: URL, headers: [String: CustomStringConvertible]) -> OSCAConfigRequestResource {
    return OSCAConfigRequestResource(
      baseURL: baseURL,
      headers: headers)
  }
}
