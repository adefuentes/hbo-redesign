//
//  HBOApiError.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation


public enum HBOApiError: Error {
    case encoding
    case decoding
    case server(message: String)
}
