//
//  APICaller.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 9/11/21.
//

import Foundation
import Moya

final class APICaller {
    
    static let shared = APICaller()
    
    final let provider = MoyaProvider<SPTAPI>()
    
}
