//
//  DataLoader.swift
//  GoustoTest
//
//  Created by Капитан on 01.06.17.
//  Copyright © 2017 OleksiyCheborarov. All rights reserved.
//

import Foundation

class APILoader : NSObject {
    
    static fileprivate let productURL = "https://api.gousto.co.uk/products/v2.0/products?includes[]=categories&image_sizes[]=750"
    static fileprivate let session = URLSession.shared
    
    class fileprivate func loadDataFromURL(path: String, completion: @escaping (_ result: Data?, _ error: NSError?) -> Void ) {
        let url = NSURL(string: path)
        let request = URLRequest(url: url! as URL)
        
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response:URLResponse?, error:Error?) in
            completion (data, error as NSError?)
        })
        
        task.resume()
    }
    
    class func parseProductData(mapper: Mapper, success: @escaping (_ result: Bool) -> Void) {
        loadDataFromURL(path: productURL, completion: { data, error in
            if (error == nil) {
                do {
                    if let data = data,
                        let json = try JSONSerialization.jsonObject(with: data) as? [String:Any],
                        let productSource = json["data"] as? [[String: Any]] {
                        mapper.productMapper(dictionary: productSource)
                        success(true)
                    }
                } catch {
                    success(false)
                    print ("Could not parse the data as JSON: '\(String(describing: data))'")
                }
            } else {
                print ("Error when loading '\(String(describing: error))'")
            }
        })
    }
}
