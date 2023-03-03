//
//  PhotoViewModelTest.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import Foundation
import XCTest
import Combine

class PhotoViewModelTest: XCTestCase {
    
    var viewM: PhotoViewModel!
    private var cancellable: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let manager = ServiceManager()
        viewM = PhotoViewModel(manager: ServiceManager())
        viewM.getPhotosList()
    }
    
    override func tearDownWithError() throws {
        viewM = nil
        try super.tearDownWithError()
    }
    
    func testTableViewFirstCellData() {
        viewM.$photoList.sink { list in
            guard list.count > 0 else { return }
            let indexPath = IndexPath(row: 0, section: 0)
            let firstObject = self.viewM.cellForRowValue(indexPath: indexPath)
            XCTAssertEqual(firstObject?.author ?? "", "Alejandro Escamilla")
        }.store(in: &cancellable)
    }
    
}
