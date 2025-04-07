//
//  OSCAContact+DeeplinkURL.swift
//  OSCAContact
//
//  Created by Stephan Breidenbach on 12.07.22.
//

import Foundation

extension OSCAContact {
  func deeplinkURL( with deeplinkURL: DeeplinkURL) -> String {
    return "\(self.deeplinkScheme)://\(deeplinkURL.rawValue)"
  }// end public static func deeplinkURL
  
  public var contactFormDeeplinkURL: String {
    return deeplinkURL(with: .contactForm)
  }// end public var contactFormDeeplinkURL
  
  public var contactPickerDeeplinkURL: String {
    return deeplinkURL(with: .contactPicker)
  }// end public var contactPickerDeeplinkURL
}// end public static func deeplinkURL
