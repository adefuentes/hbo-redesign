//
//  HBOAPIRequest.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

public protocol HBOAPIRequest: Encodable {
    
    associatedtype Response: Decodable
    
    var resourceName: String { get }
}
