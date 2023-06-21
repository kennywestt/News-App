//
//  APICaller.swift
//  IosProject
//
//  Created by 이경근 on 2023/06/19.
//

import Foundation

final class GetAPI {
    static let shared = GetAPI()
    
    struct Constants {
        static let topHeadlineURL = URL(string:
            "https://newsapi.org/v2/top-headlines?country=kr&apiKey=91b46f919b8f49ce91004cf23367d4ca")
        static let searchUrlString =
        "https://newsapi.org/v2/everything?sortedBy=popularity&apiKey=91b46f919b8f49ce91004cf23367d4ca&q="
    }
    
    private init() {}
    
    public func getTopStories(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/top-headlines?country=kr&category=\(category)&apiKey=91b46f919b8f49ce91004cf23367d4ca"
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    public func search(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urltring = Constants.searchUrlString + query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        // 검색어를 URL에 포함하기 위해 인코딩합니다.
        guard let url = URL(string: urltring) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}

// models

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}

struct Source: Codable {
    let name: String
}
