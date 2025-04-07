//
//  OSCAUploadClassRequestResource+ContactFormData.swift
//  OSCAContact
//
//  Created by Stephan Breidenbach on 03.02.22.
//  Reviewed by Stephan Breidenbach on 02.02.23
//

import Foundation
import OSCANetworkService


extension OSCAUploadClassRequestResource{
  /// `OSCAUploadClassRequestResource` for contact-form's data`
  /// - Parameters:
  ///   - baseURL: The root url of your parse-server
  ///   - headers: The authentication headers for your parse-server
  ///   - uploadParseClassObject: the parse clase object requested for upload
  /// - Returns: A ready to use `OSCAUploadClassRequestResource`
  static func contactFormData( baseURL: URL,
                               headers: [String: CustomStringConvertible],
                               uploadParseClassObject: OSCAContactFormData? ) -> OSCAUploadClassRequestResource<OSCAContactFormData>{
    let parseClassName = OSCAContactFormData.parseClassName
    return OSCAUploadClassRequestResource<OSCAContactFormData>(
      baseURL: baseURL,
      parseClass: parseClassName,
      uploadParseClassObject: uploadParseClassObject,
      headers: headers)
  }// end static func contactFormData
}// end extension public struct OSCAUploadClassRequestResource
