//
//  NetManagerNews.swift
//  PlayVideo
//
//  Created by User on 1/3/19.
//  Copyright © 2019 DenisBaturitskiy. All rights reserved.
//
import Alamofire
import Foundation

var globalLocation = ""
let urlNews = "https://kudago.com/public-api/v1.2/news/"
let urlDetailNews = "https://kudago.com/public-api/v1.4/news/"




struct NewsDictionary:Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [ResultDictionary]
}

struct ResultDictionary: Decodable {
    var id : Int
    var title: String
    var body_text: String
    var images : [ImagArray]
}


struct ImagArray: Decodable {
   var image: String
   var source: SourceDictionary
}

struct SourceDictionary: Decodable {
    var name: String
    var link: String
}

struct DetailNews: Decodable {
    var description: String
    var body_text: String
}


final class NetManagerNews: NSObject {
    
    static func getNewsImages(url: String,location: String,complition: @escaping(NewsDictionary) -> Void) {
        let params = ["fields":"publication_date,title,images,id,body_text","location":location]
        Alamofire.request(url,
                   method: HTTPMethod.get,
                   parameters: params).responseJSON {
                    response in
                    
                    switch response.result {
                    case .success:
                        guard let data = response.data else { return }
                        do {
                            let object = try JSONDecoder().decode(NewsDictionary.self, from: data)
                            complition(object)
                        } catch let error {
                            print(error)
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
        }
    }
    
    static func getNewsDetail(id: Int, complition: @escaping(DetailNews) -> Void) {
        
        let newsIdStr = String(id)
        let newUrl = urlDetailNews + newsIdStr
        
        Alamofire.request(newUrl,
                          method: HTTPMethod.get,
                          parameters: nil).responseJSON {
                            response in
                            
                            switch response.result {
                            case .success:
                                guard let data = response.data else { return }
                                do {
                                    let object = try JSONDecoder().decode(DetailNews.self, from: data)
                                    complition(object)
                                } catch let error {
                                    print(error)
                                }
                                break
                            case .failure(let error):
                                print(error)
                            }
        }
    }
}

