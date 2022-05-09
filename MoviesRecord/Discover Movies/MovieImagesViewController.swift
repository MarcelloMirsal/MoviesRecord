//
//  MovieImagesViewController.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 20/04/2022.
//

import UIKit
import SwiftUI
import Kingfisher
import TheMovieDBService
import Combine



struct MovieImagesView: UIViewControllerRepresentable {
    let movieID: String
    func makeUIViewController(context: Context) -> MovieImagesViewController {
        return MovieImagesViewController(movieID: movieID)
    }
    
    
    func updateUIViewController(_ uiViewController: MovieImagesViewController, context: Context) {
        
    }
    
}

struct MovieImagesViewPreview: PreviewProvider {
    
    static var previews: some View {
        MovieImagesView(movieID: "634649")
    }
    
}


class MovieImagesViewController: UIViewController {
    let movieID: String
    let movieDBService: TheMovieDBService
    let taskProgressView = UIHostingController(rootView: TaskProgressView()).view
    var tryAgainFeedButton: UIView!
    @Published private var requestState = FeedRequestState.success
    private var cancellable = Set<AnyCancellable>()
    fileprivate var dataSource: UICollectionViewDiffableDataSource<Section, MovieImagesResponse.MovieImage>!
    
    init(movieID: String) {
        self.movieID = movieID
        self.movieDBService = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViews()
        $requestState.sink { [weak self] newRequestState in
            UIView.animate(withDuration: 0.25) {
                self?.taskProgressView?.isHidden = newRequestState != .loading
                self?.tryAgainFeedButton?.isHidden = newRequestState != .error
            }
        }.store(in: &cancellable)
        let cellRegistration: UICollectionView.CellRegistration<MovieImageCell, MovieImagesResponse.MovieImage> = .init { [weak self] cell, indexPath, movieImage in
            cell.set(imageURL: self?.getImageURL(imagePath: movieImage.filePath))
        }
        
        let cellProvider: (UICollectionView, IndexPath, MovieImagesResponse.MovieImage) -> MovieImageCell = { collectionView, indexPath, movieImage in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: movieImage)
        }
        dataSource = .init(collectionView: collectionView, cellProvider: cellProvider)
        collectionView.dataSource = dataSource
        Task { [weak self] in
            await self?.requestMovieImages()
        }
    }
    
    private func setupViews() {
        guard let taskProgressView = taskProgressView else { return }
        taskProgressView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(taskProgressView)
        taskProgressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        taskProgressView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        tryAgainFeedButton = UIHostingController(rootView: TryAgainFeedButton.init(descriptionMessage: "Can't load images", action: { [weak self] in
            Task { [weak self] in
                await self?.requestMovieImages()
            }
        })).view
        
        tryAgainFeedButton.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(tryAgainFeedButton, aboveSubview: taskProgressView)
        tryAgainFeedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tryAgainFeedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    private func set(requestState: FeedRequestState) {
        self.requestState = requestState
    }
    
    @MainActor
    func requestMovieImages() async {
        guard requestState != .loading else { return }
        set(requestState: .loading)
        let result = await movieDBService.requestMovieImages(movieID: movieID, decodingType: MovieImagesResponse.self)
        switch result {
        case .success(let response):
            set(requestState: .success)
            var currentSnapshot = dataSource.snapshot()
            currentSnapshot.appendSections([.backdrops, .posters])
            currentSnapshot.appendItems(response.backdrops!, toSection: .backdrops)
            currentSnapshot.appendItems(response.posters!, toSection: .posters)
            await dataSource.apply(currentSnapshot)
        case .failure:
            set(requestState: .error)
        }
    }
    
    // MARK: setup views
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.setCollectionViewLayout(MovieImagesLayout().imagesLayout(), animated: true)
    }
    
    enum Section {
        case backdrops
        case logos
        case posters
    }
    
    func getImageURL(imagePath: String) -> URLRequest {
        let router = TheMovieDBServiceRouter()
        return router.imageRequest(forImageId: imagePath)
    }
}

extension MovieImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let movieImageCell = cell as? MovieImageCell else { return }
        movieImageCell.imageView.kf.cancelDownloadTask()
    }
}

fileprivate class MovieImageCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView(image: nil )
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .lightGray.withAlphaComponent(0.75)
        return imageView
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func set(imageURL: URLRequest?) {
        let delayStrategy = DelayRetryStrategy(maxRetryCount: 5, retryInterval: .seconds(3))
        imageView.kf.setImage(with: imageURL?.url, options: [.retryStrategy(delayStrategy) , .transition(.fade(0.2))])
    }
}


fileprivate struct MovieImagesResponse: Codable {
    
    let backdrops: [MovieImage]?
    let posters: [MovieImage]?
    
    struct MovieImage: Codable, Hashable {
        let filePath: String
        enum CodingKeys: String, CodingKey {
            case filePath = "file_path"
        }
    }
}
