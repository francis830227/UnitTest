//
//  ViewController.swift
//  imageDownloadDemo
//
//  Created by Francis Tseng on 2017/7/17.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
    
    }

    func fetchImage() {
        let imageURL: URL = URL(string: "http://assets.nydailynews.com/polopoly_fs/1.1344824.1368642299!/img/httpImage/image.jpg_gen/derivatives/article_750/ford-homer-simpson.jpg")!
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: imageURL, completionHandler: { (imageData, response, error) in
            
            if let data = imageData {
                print("Did download image data")
                //self.imageView.image = UIImage(data: data)
                
                //                DispatchQueue.main.async {
                //                    self.imageView.image = UIImage(data: data)
                //                }
                DispatchQueue.main.sync {
                    self.imageView.image = UIImage(data: data)
                }
                
            }
        }).resume()
    }
    
}

