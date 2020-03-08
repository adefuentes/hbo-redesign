//
//  File.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

public struct HBOGetList: HBOAPIRequest {
    public typealias Response = [HBOContent]
    
    public var resourceName: String {
        return "discover/movie"
    }
    
    // Parameters
    public let language: String?
    public let page: Int?
    
    // Note that nil parameters will not be used
    public init(language: String? = nil, page: Int?) {
        self.language = language
        self.page = page
    }
}
