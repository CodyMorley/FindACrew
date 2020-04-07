//
//  Person.swift
//  FindACrew
//
//  Created by Cody Morley on 4/6/20.
//  Copyright © 2020 Cody Morley. All rights reserved.
//

import Foundation

struct Person: Decodable {
    enum CodingKeys: String, CodingKey {
        case name, gender
        case birthYear = "birth_year"
    }
    
    let name: String
    let gender: String
    let birthYear: String
}


extension Person: Hashable {
}

struct PersonSearch: Decodable {
    let results: [Person]
}
