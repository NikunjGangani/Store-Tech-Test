//
//  SelectedPhotoViewModel.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation

class SelectedPhotoViewModel {
    
    @Published var photoList = [String]()
    
    func getPhotosList() {
        if let list = Utils.getDataFromUserDefault("SavedPhoto") as? [String] {
            photoList = list
        }
    }
}
