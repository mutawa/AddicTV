//
//  TVMazeAPI.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 04/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation

class API {
    // singleton design pattern
    static let shared = API()
    private init() {}
    
    static let baseUrl = Constants.TVMaze.url
    
    
    enum endPoint {
        case search(String)
        
        var urlString:String {
            var url = baseUrl
            switch(self) {
            case .search(let query):
                url += "search/shows?q=\(query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))"
                
            }
            return url
        }
    }
    
    func search(for title:String, callback: (([ApiShow]?,String?)->())?=nil) {
        let urlString = endPoint.search(title).urlString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data,response,error in
            DispatchQueue.main.async {
                
                guard error==nil else { callback?(nil,"Could not communicate with server. \(error!.localizedDescription)\n"); return }
                guard let data = data else { callback?(nil,"The server responded with a blank data"); return }
                
                let decoder = JSONDecoder()
                do {
                    let results = try decoder.decode([ApiResult].self, from: data)
                    
                    var shows = [ApiShow]()
                    for result in results {
                        shows.append(result.show)
                    }
                    
                    callback?(shows,nil)
                    
                } catch {
                    callback?(nil, "Could not convert server reply to Shows Array. error: \(error.localizedDescription)")
                }
            }
            
            }.resume()
    }
    
    func getImage(urlString: String, callback: ((Data?,Error?)->())?=nil) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data,response,error in
                DispatchQueue.main.async {
                    guard error==nil else { callback?(nil,error); return }
                    guard let data = data else { callback?(nil,nil); return }
                    callback?(data,nil)
                    
                }
                }.resume()
        }
    }
    
}
