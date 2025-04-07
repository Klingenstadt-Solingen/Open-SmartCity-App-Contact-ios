//
//  OSCAContactFormContact.swift
//  
//
//  Created by Stephan Breidenbach on 24.01.22.
//

import Foundation
import OSCAEssentials
/**
 A contact object of the contact form
 
 [see schema](https://git-dev.solingen.de/smartcityapp/documents/-/tree/master/X_Datastructure/1_Classes/schemas/ContactFormContact.schema.json)
 - Parameter objectId: auto generated id
 - Parameter createdAt : UTC date when the object was created
 - Parameter updatedAt : UTC date when the object was changed
 - Parameter email       : The email recipient of the contact form
 - Parameter emailSubject: The subject of the email that gets generated
 - Parameter title       : Title of the contact. Will be displayed in the dropdown menu of the contact form.
 
 */
public struct OSCAContactFormContact: OSCAParseClassObject, Equatable {
  public private(set) var objectId    : String?
  public private(set) var createdAt   : Date?
  public private(set) var updatedAt   : Date?
  public              var email       : String?
  public              var emailSubject: String?
  public              var title       : String?
  public init( objectId       : String? = nil,
               createdAt      : Date? = nil,
               updatedAt      : Date? = nil,
               email          : String? = nil,
               emailSubject   : String? = nil,
               title          : String? = nil) {
    self.objectId = objectId
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.email = email
    self.emailSubject = emailSubject
    self.title = title
  }// end public memberwise init
}// end public struct OSCAContactFormContact

extension OSCAContactFormContact {
  /// Parse class name
  public static var parseClassName : String { return "ContactFormContact" }
}// end extension OSCAContactFormData
