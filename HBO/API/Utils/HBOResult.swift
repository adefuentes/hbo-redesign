//
//  HBOResult.swift
//  HBO
//
//  Created by Angel Fuentes on 05/10/2018.
//  Copyright © 2018 Angel Fuentes. All rights reserved.
//

import Foundation

public enum HBOResult<Value> {
    case success(Value)
    case failure(Error)
}

public typealias HBOResultCallback<Value> = (HBOResult<Value>) -> Void
