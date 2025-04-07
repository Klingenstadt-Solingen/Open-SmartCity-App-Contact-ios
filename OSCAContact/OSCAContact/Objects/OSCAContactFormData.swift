//
//  OSCAContactFormData.swift
//  
//
//  Created by Stephan Breidenbach on 24.01.22.
//

import Foundation
import OSCAEssentials

/**
 ContactFormData schema
 
 [see schema](https://git-dev.solingen.de/smartcityapp/documents/-/tree/master/X_Datastructure/1_Classes/schemas/ContactFormData.schema.json)
 - Parameter objectId: auto generated id
 - Parameter createdAt : UTC date when the object was created
 - Parameter updatedAt : UTC date when the object was changed
 - Parameter name      : The full name of the sender
 - Parameter address   : The street and house number of the sender
 - Parameter postalCode: The postal code of the sender
 - Parameter city      : The city of the sender
 - Parameter phone     : The phone number of the sender
 - Parameter email     : The email of the sender
 - Parameter message   : The message of the contact form
 - Parameter contactId : The reference to the ContactFormContacts objectId
 */
public struct OSCAContactFormData: OSCAParseClassObject, Equatable {
  public init(objectId        : String? = nil,
              createdAt       : Date?   = nil,
              updatedAt       : Date?   = nil,
              name            : String? = nil,
              address         : String? = nil,
              postalCode      : String? = nil,
              city            : String? = nil,
              phone           : String? = nil,
              email           : String? = nil,
              message         : String? = nil,
              contactId       : String? = nil) {
    self.objectId   = objectId
    self.createdAt  = createdAt
    self.updatedAt  = updatedAt
    self.name       = name
    self.address    = address
    self.postalCode = postalCode
    self.city       = city
    self.phone      = phone
    self.email      = email
    self.message    = message
    self.contactId  = contactId
  }// end memberwise init
  
  public private(set) var objectId  : String?
  public private(set) var createdAt : Date?
  public private(set) var updatedAt : Date?
  public              var name      : String?
  public              var address   : String?
  public              var postalCode: String?
  public              var city      : String?
  public              var phone     : String?
  public              var email     : String?
  public              var message   : String?
  public              var contactId : String?
}// end public struct OSCAContactFormData

extension OSCAContactFormData {
  /// Parse class name
  public static var parseClassName : String { return "ContactFormData" }
}// end extension OSCAContactFormData
