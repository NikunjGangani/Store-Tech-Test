//
//  MockPhotoData.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

class MockPhotoData {
    func getFruitDataFromFile() -> Data {
        return dataFromJSON(withName: "PhotoListMockResponse")!
    }
}

func dataFromJSON(withName name: String) -> Data? {
    guard let fileURL = Bundle(for: StoreLab_TestTests.self).url(forResource: name, withExtension: "json") else {
        return nil
    }
    return try? Data(contentsOf: fileURL)
}
