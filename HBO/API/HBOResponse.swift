//
//  HBOResponse.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

public struct HBOResponse<Response: Decodable>: Decodable {
    
    public let status: String?
    public let message: String?
    public let data: HBODataContainer<Response>?
    
}
