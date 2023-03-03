//
//  PhotoViewControllerTest.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import XCTest
@testable import StoreLab_Test

class PhotoViewControllerTest: XCTestCase {
    
    private var viewM: PhotoViewModel!
    private var mockSession: ServiceManagerMock!
    private var photoController: PhotosViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mockSession = ServiceManagerMock()
        mockSession.data = MockPhotoData().getFruitDataFromFile()
        
        let viewModel = PhotoViewModel(manager: ServiceManager(session: mockSession as! ServiceSession))
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "PhotosViewController") as? PhotosViewController {
            viewM = viewModel
            photoController = controller
        }
        getPhotosData()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewM = nil
        photoController = nil
        mockSession = nil
        try super.tearDownWithError()
        
    }
    
    func getPhotosData() {
        photoController.getPhotosAPI()
        viewM.$message.sink { message in
            XCTAssertTrue(message.isEmpty)
        }
    }
}
