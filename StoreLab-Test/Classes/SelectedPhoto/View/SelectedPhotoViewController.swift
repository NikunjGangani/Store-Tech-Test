//
//  SelectedPhotoViewController.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import UIKit
import Combine

class SelectedPhotoViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(UINib(nibName: Identifier.photosCell, bundle: nil), forCellWithReuseIdentifier: Identifier.photosCell)
            collectionView?.reloadData()
        }
    }
    var viewModel: SelectedPhotoViewModel!
    private var cancellable: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupBinders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getPhotosList()
    }

}

// MARK: - Helper Methods
extension SelectedPhotoViewController {
    private func setupData() {
        
    }
    
    private func setupBinders() {
        viewModel = SelectedPhotoViewModel()
        viewModel.$photoList.sink { [weak self] (list) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }.store(in: &cancellable)
    }
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource Methods
extension SelectedPhotoViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.photosCell, for: indexPath) as? PhotosCell else { return UICollectionViewCell() }
        let url = viewModel.photoList[indexPath.row]
        cell.imgView.loadThumbnail(urlSting: url)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - 2, height: collectionView.frame.width/3 - 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let img = collectionView.cellForItem(at: indexPath) as? PhotosCell {
            if let value = img.imgView.image {
                let imageInfo   = GSImageInfo(image: value, imageMode: .aspectFit)
                let imageViewer = PhotoDetailViewController(imageInfo: imageInfo)
                present(imageViewer, animated: true, completion: nil)
            }
        }
    }
}
