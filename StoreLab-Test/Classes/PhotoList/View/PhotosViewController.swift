//
//  PhotosViewController.swift
//  StoreLab-Test
//
//  Created by Nikunj Gangani on 03/03/2023.
//

import UIKit
import Combine

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.delegate = self
            collectionView?.dataSource = self
            collectionView?.register(UINib(nibName: Identifier.photosCell, bundle: nil), forCellWithReuseIdentifier: Identifier.photosCell)
            collectionView?.reloadData()
        }
    }
    var viewModel: PhotoViewModel!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(refresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.gray
        return refreshControl
    }()
    
    private var cancellable: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupBinders()
        getPhotosAPI()
    }
}

// MARK: - Helper Methods
extension PhotosViewController {
    private func setupData() {
        self.title = Title.photos
        collectionView?.addSubview(refreshControl)
    }
    
    private func setupBinders() {
        viewModel = PhotoViewModel(manager: ServiceManager())
        viewModel.$photoList.sink { [weak self] (list) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.stopIndicator()
                self.collectionView?.reloadData()
            }
        }.store(in: &cancellable)
        
        viewModel.$message.sink { message in
            DispatchQueue.main.async {
                self.stopIndicator()
            }
            print("\(message)")
        }.store(in: &cancellable)
    }
    
    func getPhotosAPI() {
        startIndicator()
        viewModel.getPhotosList()
    }
    
    private func startIndicator() {
        indicator.startAnimating()
    }
    
    private func stopIndicator() {
        indicator.stopAnimating()
    }
}

// MARK: - Actions
extension PhotosViewController {
    @objc func refresh(_ sender: AnyObject) {
        viewModel.pageIndex = 1
        viewModel.apiState = .initial
        getPhotosAPI()
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier.photosCell, for: indexPath) as? PhotosCell else { return UICollectionViewCell() }
        let url = viewModel.photoList[indexPath.row].download_url ?? ""
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let url = viewModel.photoList[indexPath.row].download_url ?? ""
        if viewModel.photoList.count - 2 == indexPath.item && viewModel.apiState == .completed {
            viewModel.pageIndex += 1
            viewModel.getPhotosList()
        }
    }
}

