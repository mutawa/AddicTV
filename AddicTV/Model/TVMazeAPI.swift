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
    
    func search(for title:String, callback: ((String?)->())?=nil) {
        let url = endPoint.search(title).urlString
        URLSession.shared.dataTask(with: URL(string: url)!) { data,response,error in
            guard error==nil else { callback?("Could not call API. \(error!.localizedDescription)\n\(url)"); return }
            guard let data = data else { callback?("no data"); return }
            
            print(String(bytes: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let result = try decoder.decode([TVMazeResult].self, from: data)
                print("we have \(result.count)")
            } catch {
                print("error: \(error.localizedDescription)")
            }
            
            
            
        }.resume()
    }
}
