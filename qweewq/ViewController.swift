//
//  ViewController.swift
//  qweewq
//
//  Created by Admin on 31.10.17.
//  Copyright © 2017 NB. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var tUrls:[String] = []
    override func viewDidLoad() {
        getUrls()
    }

    func getUrls() {
        let url = "http://app.fingo.pro/api/v3/products/popular?format=json"
        let jsonUrl = NSURL(string:url)
        let jsonData = try? NSData(contentsOf: jsonUrl! as URL, options: NSData.ReadingOptions.uncached)
        let parsedJson = try! JSONSerialization.jsonObject(with: jsonData! as Data, options: .mutableContainers)
        for index in 0..<9 {
            
            
            if let firstArray = parsedJson as? NSArray {
                if let firstDict = firstArray[index] as? NSDictionary {
                    if let secondArray = firstDict["variants"] as? NSArray {
                        if let secondDict = secondArray[0] as? NSDictionary {
                            if let thirdDict = secondDict["image"] as? NSDictionary {
                                if let fourtDict = thirdDict["large"] as? NSDictionary {
                                    if let fifthDict = fourtDict["url"] as? String {
                                        tUrls.append("http://app.fingo.pro/" + fifthDict)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
    func getImage(_ urlString: String, _ imageView:UIImageView) {
        let url:URL = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if data != nil {
                let image = UIImage(data: data!)
                if image != nil {
                    DispatchQueue.main.async(execute: {
                        imageView.image = image
                    })
                }
            }
        })
        task.resume()
        /*
         let imgUrl : NSURL = NSURL(string: tUrls[indexPath.row])!
         let imgData:NSData = NSData(contentsOf: imgUrl as URL)!
         let imageE = UIImage(data: imgData as Data)
         cell.imageViewLoad.image = imageE
         */
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tUrls.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ImageTableViewCell", owner: self, options: nil)?.first as! ImageTableViewCell
        getImage(tUrls[indexPath.row], cell.imageViewCell)

        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 265
    }

}

