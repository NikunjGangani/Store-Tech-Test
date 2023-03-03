//
//  Photo.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

struct Photo: Codable {
    let id : String?
    let author : String?
    let width : Int?
    let height : Int?
    let url : String?
    let download_url : String?
}
