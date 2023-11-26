//
//  NewsViewModel.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

protocol NewsViewModelDelegate: AnyObject {
    func newsFetched(_ news: [News])
    func showError(_ error: Error)
}

protocol NewsViewModel: AnyObject {
    var delegate: NewsViewModelDelegate? { get set }
    func viewDidLoad()
}

final class DefaultNewsViewModel: NewsViewModel {
    
    // MARK: - Properties
    private let newsAPI = "https://newsapi.org/v2/everything?q=tesla&from=2023-11-22&sortBy=publishedAt&apiKey=0e34480169b5418f9fc2a24453bd454d"
    
    private var newsList = [News]()

    weak var delegate: NewsViewModelDelegate?

    // MARK: - Public Methods
    func viewDidLoad() {
        fetchNews()
    }
    
    // MARK: - Private Methods
    private func fetchNews() {
        NetworkManager.shared.get(url: newsAPI) { [weak self] (result: Result<Article, Error>) in
            switch result {
            case .success(let article):
                self?.newsList = article.articles
                self?.delegate?.newsFetched(article.articles)
            case .failure(let error):
                self?.delegate?.showError(error)
            }
        }
    }
}

