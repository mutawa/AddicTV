//
//  TVMazeAPI.swift
//  AddicTV
//
//  Created by Ahmad Al-Mutawa on 04/07/2019.
//  Copyright © 2019 Ahmad Al-Mutawa. All rights reserved.
//

import Foundation

class TVMazeAPI {
    // singleton design pattern
    static let shared = TVMazeAPI()
    private init() {}
    
    static let baseUrl = "https://api.tvmaze.com/"
    
    enum endPoint {
        case search(String)
        case lookup(String)
        
        var urlString:String {
            
            var url = baseUrl
            switch(self) {
            case .search(let query):
                url += "search/shows?q=\(query.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil))"
            case .lookup(let imdb):
                url += "lookup/\(imdb)"
            }
            return url
        }
    }
    
    func search(for title:String, callback: (([TVMazeShow]?,String?)->())?=nil) {
        let urlString = endPoint.search(title).urlString
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data,response,error in
            guard error==nil else { callback?(nil,"Could not call API. \(error!.localizedDescription)\n\(url)"); return }
            guard let data = data else { callback?(nil,"no data"); return }
            
            //print(String(bytes: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let results = try decoder.decode([TVMazeResult].self, from: data)
                var shows = [TVMazeShow]()
                for result in results {
                    
                    shows.append(result.show)
                }
                DispatchQueue.main.async {
                    callback?(shows,nil)
                }
                
                
            } catch {
                callback?(nil, "error: \(error.localizedDescription)")
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
