//
//  OSCAContactParseConfigParams.swift
//  OSCAContact
//
//  Created by Ömer Kurutay on 26.08.22.
//

import Foundation
import OSCAEssentials

/// An object for the parse-server configs
public struct OSCAContactParseConfig {
  public init(params: JSON? = nil,
              masterKeyOnly: JSON? = nil) {
    self.params = params
    self.masterKeyOnly = masterKeyOnly
  }// end public init
  
  /// Contains all parse-server config parameters declared in `Params`.
  public var params: JSON?
  
  public var masterKeyOnly: JSON?
  
  public var privacyText: String? {
    guard let params = self.params,
          let privacyTextString: String = params["privacyText"] else { return nil }
    return privacyTextString
  }// end public var privacyText
}// end public struct OSCAContactParseConfig

extension OSCAContactParseConfig: OSCAParseConfig {}
